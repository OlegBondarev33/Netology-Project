variable "yc_token" {
  type        = string
  description = "Yandex Cloud API Token"
  sensitive   = true
}

variable "yc_cloud_id" {
  type        = string
  description = "Yandex Cloud ID"
}

variable "yc_folder_id" {
  type        = string
  description = "Yandex Cloud Folder ID"
}

variable "default_zone" {
  type        = string
  description = "Default availability zone"
  default     = "ru-central1-a"
}

variable "second_zone" {
  type        = string
  description = "Second availability zone"
  default     = "ru-central1-b"
}

variable "subnet_name" {
  type        = string
  description = "Name of the subnet"
  default     = "default-subnet"
}

variable "vm_prefix" {
  type        = string
  description = "Prefix for VM names"
  default     = "internal-vm"
}

variable "image_id" {
  type        = string
  description = "ID of the Yandex Cloud image to use"
  default     = "fd8arv291825p8bbvmb1"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH Public Key for accessing the VMs"
}

variable "vm_size" {
  type        = string
  description = "VM instance type (cores, memory)"
  default     = "standard-v1-small"
}

variable "your_ip_address" {
  type        = string
  description = "Your public IP address (for SSH access to the bastion)"
  default = "93.157.168.26/32" # Replace with your actual IP!  (e.g., "123.45.67.89/32")
}

variable "alb_name" {
  type        = string
  description = "Name for the Application Load Balancer"
  default     = "my-alb"
}

variable "healthcheck_path" {
  type        = string
  description = "Healthcheck path for backend group"
  default     = "/"
}

variable "zabbix_version" {
  type        = string
  description = "Zabbix version to install"
  default     = "7.2"
}

variable "vm_prefix" {
  type        = string
  description = "Prefix for VM names"
  default     = "vm-zabbix"
}
