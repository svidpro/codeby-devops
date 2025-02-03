# Terraform commands

.PHONY: tf-init-yac

tf-init-yac:
	@echo "Obtaining YC_TOKEN, YC_CLOUD_ID, and YC_FOLDER_ID..."
	@export YC_TOKEN=$$(yc iam create-token); \
	YC_CLOUD_ID=$$(yc config get cloud-id); \
	YC_FOLDER_ID=$$(yc config get folder-id); \
	echo "Initialized with YC_TOKEN: $${YC_TOKEN}, YC_CLOUD_ID: $${YC_CLOUD_ID}, YC_FOLDER_ID: $${YC_FOLDER_ID}"; \

.PHONY: tf-init

tf-init:
	terraform -chdir="./terraform" init

.PHONY: tf-plan

tf-plan:
	terraform -chdir="./terraform" plan -var-file="yandex_cloud.tfvars"

.PHONY: tf-apply

tf-apply:
	terraform -chdir="./terraform" apply -var-file="yandex_cloud.tfvars"

# Yandex CLI commands

.PHONY: vm-start vm-stop

vm-start:
	yc compute instance start --name diplom_app_vm-1

vm-stop:
	yc compute instance stop --name diplom_app_vm-1

# Start Vagrant VM with Ansible commands

.PHONY: vag-up vag-up-prov vag-ssh-ansible

vag-up:
	VAGRANT_CWD=ansible/ vagrant up

vag-up-prov:
	VAGRANT_CWD=ansible/ vagrant up --provision

vag-ssh-ansible:
	VAGRANT_CWD=ansible/ vagrant ssh ansible		

# Подключение к VM на клауде

.PHONY: ssh-vm-1

ssh-vm-1:
	ssh -i ~/.ssh/yandex_cloud_codeby -l ubuntu 62.84.113.67