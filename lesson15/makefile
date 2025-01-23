.PHONY: terraform-init

terraform-init:
	@echo "Obtaining YC_TOKEN, YC_CLOUD_ID, and YC_FOLDER_ID..."
	@export YC_TOKEN=$$(yc iam create-token); \
	YC_CLOUD_ID=$$(yc config get cloud-id); \
	YC_FOLDER_ID=$$(yc config get folder-id); \
	echo "Initialized with YC_TOKEN: $${YC_TOKEN}, YC_CLOUD_ID: $${YC_CLOUD_ID}, YC_FOLDER_ID: $${YC_FOLDER_ID}"; \
	make terraform-init-command

terraform-init-command:
	@echo "Running terraform init..."
	terraform init

.PHONY: terraform-plan

terraform-plan:
	terraform plan -var-file="yandex_cloud.tfvars"

.PHONY: terraform-apply

terraform-apply:
	terraform apply -var-file="yandex_cloud.tfvars"	