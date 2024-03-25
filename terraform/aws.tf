variable "instance_count" {
  description = "Number of EC2 instances to create"
  default     = 3
}

variable "instance_type" {
  description = "AWS EC2 instance yype"
  default = "t3.2xlarge"
}

resource "aws_instance" "worldcoin-servers" {
  count         = var.instance_count
  ami           = data.aws_ami.debian_latest.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.deploy_key.key_name
  user_data     = templatefile("${path.module}/user_data/webservers.yml", { hostname = "worldcoin-${count.index + 1}" })
  security_groups = [aws_security_group.allow_ssh.name]

  tags = {
    Name = "worldcoin-${count.index + 1}"
  }
}

data "aws_ami" "debian_latest" {
  most_recent = true

  owners = ["136693071363"]

  filter {
    name = "name"
    values = ["debian-12-amd64-*"]
  }
}

resource "aws_key_pair" "deploy_key" {
  key_name   = "tomascasagrande"
  public_key = file("~/.ssh/id_ed25519.pub")
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "web_servers" {
  value = {
    for server in aws_instance.worldcoin-servers:
    server.tags.Name => server.public_ip
  }
}
