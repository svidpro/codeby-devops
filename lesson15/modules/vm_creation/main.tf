terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

data "yandex_vpc_subnet" "subnets" {
  for_each  = toset(var.vpc_subnet_list)
  subnet_id = each.value

}

locals {
  subnet_id_for_create = (
    [for subnet in data.yandex_vpc_subnet.subnets :
    subnet.subnet_id if subnet.zone == var.target_zone]
  )[0]
}

resource "yandex_compute_instance" "created-vm" {
  name        = "created-vm"
  platform_id = "standard-v2"
  resources {
    cores  = 2
    memory = 2
  }
  boot_disk {
    initialize_params {
      image_id = "fd8v0s6adqu3ui3rsuap"
    }
  }
  network_interface {
    subnet_id = local.subnet_id_for_create
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/yandex_cloud_codeby.pub")}"
  }
}
