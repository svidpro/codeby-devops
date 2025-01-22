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

module "yc-vpc" {
  source              = "github.com/terraform-yc-modules/terraform-yc-vpc.git"
  network_name        = "codeby-module-network"
  network_description = "Codeby network created with module"
  private_subnets = [{
    name           = "public-subnet"
    zone           = "ru-central1-a"
    v4_cidr_blocks = ["10.10.0.0/24"]
    },
    {
      name           = "private-subnet"
      zone           = "ru-central1-a"
      v4_cidr_blocks = ["10.11.0.0/24"]
    }
  ]
}

resource "yandex_compute_instance" "public_vm" {
  count       = 1
  name        = "public-vm-1"
  zone        = "ru-central1-a"
  platform_id = "standard-v1"
  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.image_os # data.yandex_compute_image.last_ubuntu.id
    }
  }

  network_interface {
    subnet_id = var.public_subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/yandex_cloud_codeby.pub")}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y nginx",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/yandex_cloud_codeby")
      host        = yandex_compute_instance.public_vm[0].network_interface[0].nat_ip_address
    }
  }
}

resource "yandex_compute_instance" "private_vm" {
  count       = 1
  name        = "private-vm-1"
  zone        = "ru-central1-a"
  platform_id = "standard-v1"
  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.image_os # data.yandex_compute_image.last_ubuntu.id
    }
  }

  network_interface {
    subnet_id = var.private_subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/yandex_cloud_codeby.pub")}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y nginx",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/yandex_cloud_codeby")
      host        = yandex_compute_instance.public_vm[0].network_interface[0].nat_ip_address
    }
  }
}
