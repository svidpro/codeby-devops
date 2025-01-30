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

resource "yandex_vpc_address" "vpc_address_app" {
  external_ipv4_address {
    zone_id = "ru-central1-a"
  }
}

resource "yandex_vpc_address" "vpc_address_service" {
  external_ipv4_address {
    zone_id = "ru-central1-a"
  }
}

# Добавляем первую виртуальную машину для app
resource "yandex_compute_instance" "diplom_app_vm" {
  name        = "diplom_app_vm-1"
  zone        = "ru-central1-a"
  platform_id = "standard-v1"
  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.image_os
      size     = 10
    }
  }

  network_interface {
    subnet_id      = var.public_subnet_id
    nat            = true
    nat_ip_address = yandex_vpc_address.vpc_address_app.external_ipv4_address[0].address
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/yandex_cloud_codeby.pub")}"
  }
}

# Добавляем вторую виртуальную машину для сервисов
resource "yandex_compute_instance" "diplom_vm_services" {
  name        = "diplom_vm_services-1"
  zone        = "ru-central1-a"
  platform_id = "standard-v1"
  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.image_os
      size     = 10
    }
  }

  network_interface {
    subnet_id      = var.public_subnet_id
    nat            = true
    nat_ip_address = yandex_vpc_address.vpc_address_service.external_ipv4_address[0].address
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/yandex_cloud_codeby.pub")}"
  }
}

output "public_ip_app" {
  value       = yandex_vpc_address.vpc_address_app.external_ipv4_address[0].address
  description = "The public IP address of the created app VM."
}

output "public_ip_services" {
  value       = yandex_vpc_address.vpc_address_service.external_ipv4_address[0].address
  description = "The public IP address of the created services VM."
}
