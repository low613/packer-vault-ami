packer {
  required_plugins {
    amazon = {
      version = "1.1.3"
      source  = "github.com/hashicorp/amazon"
    }
    ansible = {
      version = "1.0.3"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

variable "aws_region" {
  type = string
  default  = "ap-southeast-2"
}

data "amazon-ami" "ubuntu-jammy" {
  most_recent = true
  filters = {
    name   = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
    virtualization-type = "hvm"
  }
  owners = ["099720109477"] # Canonical
}


source "amazon-ebs" "aws" {
  region        = var.aws_region
  source_ami    = data.amazon-ami.ubuntu-jammy.id
  instance_type = "t3.nano"
  ssh_username  = "ubuntu"
  ami_name      = "vault-ubuntu-jammy {{timestamp}}"
}

build {
  sources = [
    "source.amazon-ebs.aws"
  ]

  provisioner "ansible" {
    use_proxy = false
    user = "ubuntu"
    playbook_file = "./ansible/playbook.yml"
  }
}
