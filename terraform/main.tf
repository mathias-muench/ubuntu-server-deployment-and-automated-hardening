terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_default_vpc" "default" {
}

resource "aws_security_group" "allow_all" {
  vpc_id = aws_default_vpc.default.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_all_ipv4" {
  security_group_id = aws_security_group.allow_all.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "allow_all_ipv6" {
  security_group_id = aws_security_group.allow_all.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_ipv4" {
  security_group_id = aws_security_group.allow_all.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_ipv6" {
  security_group_id = aws_security_group.allow_all.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1"
}

resource "aws_instance" "web_server" {
  availability_zone      = "eu-west-1b"
  ami                    = "ami-0d940f23d527c3ab1"
  instance_type          = "t3.micro"
  key_name               = "id_rsa"
  vpc_security_group_ids = [aws_security_group.allow_all.id]
}

resource "aws_eip" "external" {
  instance = aws_instance.web_server.id
}

resource "aws_subnet" "internal" {
  vpc_id            = aws_default_vpc.default.id
  availability_zone = "eu-west-1b"
  cidr_block        = "172.31.160.0/20"
}

resource "aws_network_interface" "internal" {
  subnet_id = aws_subnet.internal.id

  attachment {
    instance     = aws_instance.web_server.id
    device_index = 1
  }
}
