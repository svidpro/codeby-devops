terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = var.auth_token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = "ru-central1-a"
}

module "subnet_data" {
  source   = "./modules/subnet_data"
  vpc_name = var.vpc_name
}

output "subnet_list" {
  value = module.subnet_data.subnets_info
}

module "vm_creation" {
  source          = "./modules/vm_creation"
  vpc_subnet_list = module.subnet_data.subnets_info
  target_zone     = "ru-central1-a"
}
