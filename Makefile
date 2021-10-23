.PHONY: help
help:
	@echo "Available commands: "
	@echo "	– make init "
	@echo "	– make plan "
	@echo "	– make deploy "
	@echo "	– make format "
	@echo "	– make destroy "

.PHONY: init
init:
	terragrunt run-all init

.PHONY: plan
plan:
	terragrunt run-all plan

.PHONY: deploy
deploy:
	terragrunt run-all apply

.PHONY: destroy
destroy:
	terragrunt run-all destroy

.PHONY: format
format:
	terraform fmt -recursive
	terragrunt hclfmt
