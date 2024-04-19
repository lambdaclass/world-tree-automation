resource "aws_instance" "worldcoin-servers" {
  count         = var.servers
  ami           = data.aws_ami.debian_latest.id
  instance_type = var.instance_type
  user_data     = templatefile("${path.module}/user_data/worldcoin.yml", { hostname = "worldcoin-${count.index + 1}" })
  security_groups = [aws_security_group.firewall.name]

  root_block_device {
    volume_size = 80
  }

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

resource "aws_security_group" "firewall" {
  name        = "worldcoin-firewall"
  description = "Allow SSH and HTTP inbound traffic."
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
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
