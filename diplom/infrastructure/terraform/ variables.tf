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

variable "ssh_pub_key" {
  description = "SSH publick key for yandex cloud servers"
  type        = string
}

variable "public_subnet_id" {
  description = "ID Public Subnet"
  type        = string
}

variable "image_os" {
  description = "Image OS"
  type        = string
}
