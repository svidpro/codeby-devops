.PHONY: terraform-init-yac
# Terraform commands

terraform-init-yac:
	@echo "Obtaining YC_TOKEN, YC_CLOUD_ID, and YC_FOLDER_ID..."
	@export YC_TOKEN=$$(yc iam create-token); \
	YC_CLOUD_ID=$$(yc config get cloud-id); \
	YC_FOLDER_ID=$$(yc config get folder-id); \
	echo "Initialized with YC_TOKEN: $${YC_TOKEN}, YC_CLOUD_ID: $${YC_CLOUD_ID}, YC_FOLDER_ID: $${YC_FOLDER_ID}"; \

.PHONY: terraform-init

terraform-init:
	terraform -chdir="./terraform" init

.PHONY: terraform-plan

terraform-plan:
	terraform -chdir="./terraform" plan -var-file="yandex_cloud.tfvars"

.PHONY: terraform-apply

terraform-apply:
	terraform -chdir="./terraform" apply -var-file="yandex_cloud.tfvars"

# Yandex CLI commands

.PHONY: vm-start vm-stop

vm-start:
	yc compute instance start --name diplom_app_vm-1

vm-stop:
	yc compute instance stop --name diplom_app_vm-1