# กำหนด Provider (ตัวอย่าง: DigitalOcean)
terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

variable "do_token" {
  description = "DigitalOcean API Token"
  sensitive   = true
}

provider "digitalocean" {
  token = var.do_token
}

# สร้าง Cloud Server (Droplet)
resource "digitalocean_droplet" "sentinella_node" {
  image  = "docker-20-04"
  name   = "sentinella-ops-prod"
  region = "sgp1"
  size   = "s-1vcpu-2gb"
  ssh_keys = ["your_ssh_key_id"] # เปลี่ยนเป็น SSH Key ID ของคุณ

  # ใส่สคริปต์เพื่อให้มันรันแอปทันทีเมื่อเครื่องเปิดขึ้นมา (User Data)
  user_data = <<-EOF
              #!/bin/bash
              git clone https://github.com/your-username/Sentinella-Ops.git
              cd Sentinella-Ops
              docker-compose up -d
              EOF
}

output "ip_address" {
  value = digitalocean_droplet.sentinella_node.ipv4_address
}
