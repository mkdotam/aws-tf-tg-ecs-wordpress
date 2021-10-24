resource "aws_ecs_cluster" "cluster" {
  name = "${var.project}-${var.env}-ecs"

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]
  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
  }

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = var.tags
}

resource "aws_ecs_service" "service" {
  name            = "${var.project}-${var.env}-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn

  desired_count                     = 1
  launch_type                       = "FARGATE"
  health_check_grace_period_seconds = 60
  wait_for_steady_state             = true
  force_new_deployment              = true

  network_configuration {
    assign_public_ip = false
    subnets          = var.private_subnets
    security_groups  = [aws_security_group.ecs_sg.id]
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arns[0]
    container_name   = var.project
    container_port   = var.container_port
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  deployment_controller {
    type = "ECS"
  }

  tags = var.tags
}

resource "aws_ecs_task_definition" "task" {
  family = "${var.project}-${var.env}-task"

  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory

  task_role_arn      = aws_iam_role.ecs_task.arn
  execution_role_arn = aws_iam_role.ecs_task_exec.arn

  container_definitions = jsonencode([
    {
      name : var.project,
      image : "wordpress:5.8-php7.4-apache",
      essential : true,
      memory : var.task_memory,
      portMappings : [
        {
          "protocol" : "tcp",
          "containerPort" : var.container_port,
          "hostPort" : var.host_port
        }
      ],
      secrets = [
        {
          "name" : "WORDPRESS_DB_HOST",
          "valueFrom" : "${var.db_secrets_arn}:host::"
        },
        {
          "name" : "WORDPRESS_DB_USER",
          "valueFrom" : "${var.db_secrets_arn}:username::"
        },
        {
          "name" : "WORDPRESS_DB_PASSWORD",
          "valueFrom" : "${var.db_secrets_arn}:password::"
        },
        {
          "name" : "WORDPRESS_DB_NAME",
          "valueFrom" : "${var.db_secrets_arn}:database::"
        }
      ],
      environment : [
        {
          "name" : "WORDPRESS_TABLE_PREFIX",
          "value" : "wp"
        },
        {
          "name" : "WP_CONTENT_DIR",
          "value" : "/var/www/html/wp-content/"
        }
      ],
      logConfiguration : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : aws_cloudwatch_log_group.ecs_task.name,
          "awslogs-region" : var.region,
          "awslogs-stream-prefix" : "ecs"
        }
      },
      mountPoints : [
        {
          "sourceVolume" : "${var.project}-service-storage",
          "containerPath" : "/var/www/html/wp-content/",
          "readOnly" : false
        }
      ]
    }
  ])

  volume {
    name = "${var.project}-service-storage"

    efs_volume_configuration {
      file_system_id          = var.efs_id
      root_directory          = "/"
      transit_encryption      = "ENABLED"
      transit_encryption_port = 2999
      authorization_config {
        access_point_id = var.efs_access_point_id
        iam             = "ENABLED"
      }
    }
  }

  tags = var.tags
}

resource "aws_appautoscaling_target" "target" {
  max_capacity       = 5
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.cluster.name}/${aws_ecs_service.service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "memory" {
  name               = "${var.project}-memory"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.target.resource_id
  scalable_dimension = aws_appautoscaling_target.target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value = 80
  }
}

resource "aws_appautoscaling_policy" "cpu" {
  name               = "${var.project}-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.target.resource_id
  scalable_dimension = aws_appautoscaling_target.target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 80
  }
}

resource "aws_cloudwatch_log_group" "ecs_task" {
  name              = "/ecs/task/${var.project}-${var.env}"
  retention_in_days = 14

  tags = var.tags
}
