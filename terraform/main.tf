# Define the environment variable
variable "environment" {
  description = "The environment to deploy (dev, prod, test)"
  type        = string
  default     = "dev"
}

# Define the AWS provider
provider "aws" {
  region = "us-east-1"
}

# Create a VPC with DNS settings
resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "my-vpc-${var.environment}"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my-igw-${var.environment}"
  }
}

# Create a Route Table
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "my-route-table-${var.environment}"
  }
}

# Create Subnets in different Availability Zones
resource "aws_subnet" "my_subnet_1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "my-subnet-1-${var.environment}"
  }
}

resource "aws_subnet" "my_subnet_2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "my-subnet-2-${var.environment}"
  }
}

resource "aws_subnet" "my_subnet_3" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = true
  tags = {
    Name = "my-subnet-3-${var.environment}"
  }
}

# Create a Security Group
resource "aws_security_group" "my_sg" {
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my-sg-${var.environment}"
  }
}

# Create EC2 instances with environment-specific names
resource "aws_instance" "my_instances" {
  count         = 3
  ami           = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro"

  key_name = "thisismykey"  # Reference the existing key pair

  subnet_id = element(
    [
      aws_subnet.my_subnet_1.id,
      aws_subnet.my_subnet_2.id,
      aws_subnet.my_subnet_3.id
    ],
    count.index
  )

  vpc_security_group_ids = [aws_security_group.my_sg.id]

  tags = {
    Name = "my-instance-${var.environment}-${count.index + 1}"
  }
}

# Output the instance details.
output "instance_ids" {
  value = aws_instance.my_instances[*].id
}

output "instance_public_ips" {
  value = aws_instance.my_instances[*].public_ip
}

output "instance_public_dns" {
  value = aws_instance.my_instances[*].public_dns
}
