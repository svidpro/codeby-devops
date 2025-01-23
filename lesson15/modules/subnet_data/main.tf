terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}
data "yandex_vpc_network" "vpc" {
  name = var.vpc_name
}

output "subnets_info" {
  value = data.yandex_vpc_network.vpc.subnet_ids
}
