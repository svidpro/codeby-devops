variable "auth_token" {
  description = "Authentication token for Yandex Cloud"
  type        = string
}

variable "cloud_id" {
  description = "ID of the Yandex Cloud"
  type        = string
}

variable "folder_id" {
  description = "ID of the folder in Yandex Cloud"
  type        = string
}

variable "vpc_name" {
  description = "Имя VPC для получения подсетей"
  type        = string
}
