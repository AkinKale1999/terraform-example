provider "aws" {
  region = var.region
}

resource "aws_instance" "apache-instance" {
  ami           = var.ec2_ami
  instance_type = var.ec2_instance_type
  subnet_id     = aws_subnet.public-subnet.id
  vpc_security_group_ids = [
    aws_security_group.apache_sg.id,
    aws_security_group.maintanance_ssh_access.id
  ]
  tags = {
    Name = "ApacheServer"
  }
}

resource "aws_instance" "db-instance" {
  ami           = var.ec2_ami
  instance_type = var.ec2_instance_type
  subnet_id     = aws_subnet.public-subnet.id
  vpc_security_group_ids = [
    aws_security_group.mysql_sg.id,
    aws_security_group.maintanance_ssh_access.id
  ]
  tags = {
    Name = "DBServer"
  }
}

resource "aws_vpc" "main-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "project-18-11-2024-vpc"
  }
}

resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = var.cidr_block_only_ones
  availability_zone       = var.availability_zone_spublic_subnet
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw-main" {
  vpc_id = aws_vpc.main-vpc.id
}

resource "aws_route_table" "rt-main" {
  vpc_id = aws_vpc.main-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-main.id
  }
}

resource "aws_route_table_association" "rt-main-ass" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.rt-main.id
}

output "public-ip-db" {
  description = "The public ip of the DB"
  value       = aws_instance.db-instance.public_ip
}
output "public-ip-apache" {
  description = "The public ip of the Apache Webserver"
  value       = aws_instance.apache-instance.public_ip
}

resource "aws_security_group" "apache_sg" {
  name        = "allow_tls_80"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = var.port_egress["from_port"]
    to_port     = var.port_egress["to_port"]
    protocol    = var.port_egress["protocol"]
    cidr_blocks = var.port_egress["cidr_blocks"]
  }
}

resource "aws_security_group" "maintanance_ssh_access" {
  name        = "ssh_access_group"
  description = "allow ssh access on port 22"
  vpc_id      = aws_vpc.main-vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = var.port_egress["from_port"]
    to_port     = var.port_egress["to_port"]
    protocol    = var.port_egress["protocol"]
    cidr_blocks = var.port_egress["cidr_blocks"]
  }
}

resource "aws_security_group" "mysql_sg" {
  name        = "mysql-sg"
  description = "allow port 3306"
  vpc_id      = aws_vpc.main-vpc.id
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = var.port_egress["from_port"]
    to_port     = var.port_egress["to_port"]
    protocol    = var.port_egress["protocol"]
    cidr_blocks = var.port_egress["cidr_blocks"]
  }
}
