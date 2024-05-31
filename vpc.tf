resource "aws_vpc" "test_vpc" {
  cidr_block = "10.0.0.0/16"  # Specify the CIDR block for your VPC
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "test_subnet" {
  vpc_id                  = aws_vpc.test_vpc.id
  cidr_block              = "10.0.0.0/24"  # Specify the CIDR block for your subnet
  availability_zone       = "ap-south-1a"   # Specify the availability zone
}

resource "aws_subnet" "test_subnet_1" {
  vpc_id                  = aws_vpc.test_vpc.id
  cidr_block              = "10.0.1.0/24"  # Specify the CIDR block for your subnet
  availability_zone       = "ap-south-1b"   # Specify the availability zone
}

# Define a security group that allows SSH and HTTP
resource "aws_security_group" "instance" {
  name_prefix = "terraform-example-"
  vpc_id      = aws_vpc.test_vpc.id 

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # This means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_internet_gateway" "test_igw" {
  vpc_id = aws_vpc.test_vpc.id
}

resource "aws_route_table" "test_route_table" {
  vpc_id = aws_vpc.test_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test_igw.id
  }
}

resource "aws_route_table_association" "example_subnet_association" {
  subnet_id      = aws_subnet.test_subnet.id
  route_table_id = aws_route_table.test_route_table.id
}

resource "aws_route_table_association" "example_1__subnet_association" {
  subnet_id      = aws_subnet.test_subnet_1.id
  route_table_id = aws_route_table.test_route_table.id
}

