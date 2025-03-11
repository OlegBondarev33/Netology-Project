resource "yandex_vpc_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Security group for bastion host"
  network_id  = yandex_vpc_network.default_network.id

  ingress {
    protocol       = "tcp"
    port           = 22
    v4_cidr_blocks = [var.your_ip_address] # Only allow SSH from your IP
  }

  egress {
    protocol       = "tcp"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]  # Allow SSH to anywhere (can be restricted further)
    #from_port      = 1
    #to_port        = 65535
  }
}

resource "yandex_vpc_security_group" "internal_vms_sg" {
  name        = "internal-vms-sg"
  description = "Security group for internal VMs"
  network_id  = yandex_vpc_network.default_network.id

  ingress {
    protocol       = "tcp"
    port           = 22
    v4_cidr_blocks = ["${yandex_compute_instance.bastion.network_interface[0].ip_address}/32"]
    description = "Allow SSH from Bastion Host"
  }
  ingress {  # Добавляем это правило
    protocol       = "tcp"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP from anywhere (for testing)
    description = "Allow HTTP traffic"
  }
}
