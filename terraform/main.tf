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
    Name = "myvpc"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my-igw"
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
    Name = "my-route-table"
  }
}

# Create Subnets in different Availability Zones
resource "aws_subnet" "my_subnet_1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "my-subnet-1"
  }
}

resource "aws_subnet" "my_subnet_2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "my-subnet-2"
  }
}

resource "aws_subnet" "my_subnet_3" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = true
  tags = {
    Name = "my-subnet-3"
  }
}

# Associate Route Table with Subnets
resource "aws_route_table_association" "my_subnet_association_1" {
  subnet_id      = aws_subnet.my_subnet_1.id
  route_table_id = aws_route_table.my_route_table.id
}

resource "aws_route_table_association" "my_subnet_association_2" {
  subnet_id      = aws_subnet.my_subnet_2.id
  route_table_id = aws_route_table.my_route_table.id
}

resource "aws_route_table_association" "my_subnet_association_3" {
  subnet_id      = aws_subnet.my_subnet_3.id
  route_table_id = aws_route_table.my_route_table.id
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
    Name = "my-sg"
  }
}

# Use existing AWS Key Pair
# Create three EC2 instances, each in a different subnet
resource "aws_instance" "my_instances" {
  count         = 3
  ami           = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro"

  key_name = "ansible-server-key"  # Reference the existing key pair

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
    Name = "my-instance-${count.index + 1}"
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




/*

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
    Name = "myvpc"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my-igw"
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
    Name = "my-route-table"
  }
}

# Create a single Subnet
resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "my-subnet"
  }
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "my_subnet_association" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route_table.id
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
    Name = "my-sg"
  }
}

# Use existing AWS Key Pair
# Create a single EC2 instance
resource "aws_instance" "my_instance" {
  ami           = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro"

  key_name = "abc"  # Reference the existing key pair

  subnet_id = aws_subnet.my_subnet.id

  vpc_security_group_ids = [aws_security_group.my_sg.id]

  tags = {
    Name = "my-instance"
  }
}

# Output the instance details
output "instance_id" {
  value = aws_instance.my_instance.id
}

output "instance_public_ip" {
  value = aws_instance.my_instance.public_ip
}

output "instance_public_dns" {
  value = aws_instance.my_instance.public_dns
}





provider "aws" {
  region = "us-east-1"
}

# Create a VPC with DNS settings
resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"  
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "myvpc"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my-igw"
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
    Name = "my-route-table"
  }
}

# Create Subnets in different Availability Zones
resource "aws_subnet" "my_subnet_1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "my-subnet-1"
  }
}

resource "aws_subnet" "my_subnet_2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "my-subnet-2"
  }
}

resource "aws_subnet" "my_subnet_3" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = true
  tags = {
    Name = "my-subnet-3"
  }
}

# Associate Route Table with Subnets
resource "aws_route_table_association" "my_subnet_association_1" {
  subnet_id      = aws_subnet.my_subnet_1.id
  route_table_id = aws_route_table.my_route_table.id
}

resource "aws_route_table_association" "my_subnet_association_2" {
  subnet_id      = aws_subnet.my_subnet_2.id
  route_table_id = aws_route_table.my_route_table.id
}

resource "aws_route_table_association" "my_subnet_association_3" {
  subnet_id      = aws_subnet.my_subnet_3.id
  route_table_id = aws_route_table.my_route_table.id
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
    Name = "my-sg"
  }
}

# Create a new EC2 Key Pair
resource "aws_key_pair" "my_key_pair" {
  key_name   = "thisistfkey"
  public_key = file("~/.ssh/id_rsa.pub")  # Path to your public key file
}

# Create three EC2 instances, each in a different subnet
resource "aws_instance" "my_instances" {
  count         = 3
  ami           = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro"

  key_name = aws_key_pair.my_key_pair.key_name

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
    Name = "my-instance-${count.index + 1}"
  }
}

# Output the instance details
output "instance_ids" {
  value = aws_instance.my_instances[*].id
}

output "instance_public_ips" {
  value = aws_instance.my_instances[*].public_ip
}

output "instance_public_dns" {
  value = aws_instance.my_instances[*].public_dns
}

# Output the key pair details
output "key_pair_id" {
  value = aws_key_pair.my_key_pair.id
}
*/