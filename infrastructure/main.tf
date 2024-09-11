provider "aws" {
  region = "us-east-1"
}

# VPC, Subnets, Internet Gateway
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main_igw.id
}

# EC2 Instances (Microservices)
resource "aws_instance" "service_a" {
  ami           = "ami-0182f373e66f89c85"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  tags = {
    Name = "ServiceA"
  }
}

resource "aws_instance" "service_b" {
  ami           = "ami-0182f373e66f89c85"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  tags = {
    Name = "ServiceB"
  }
}

# Route 53 DNS
resource "aws_route53_zone" "primary" {
  name = "microservices.local"
}

resource "aws_route53_record" "service_a_dns" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "service-a.microservices.local"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.service_a.public_ip]
}

resource "aws_route53_record" "service_b_dns" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "service-b.microservices.local"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.service_b.public_ip]
}
