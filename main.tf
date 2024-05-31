# Specify the provider and version
provider "aws" {
  region = "ap-south-1"  # Change to your desired region
}

# Define a security group that allows SSH and HTTP
#resource "aws_security_group" "instance" {
#  name_prefix = "terraform-example-"
#
#  ingress {
#    from_port   = 22
#    to_port     = 22
#    protocol    = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#
#  ingress {
#    from_port   = 80
#    to_port     = 80
#    protocol    = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#
#  # Egress rules
#  egress {
#    from_port   = 0
#    to_port     = 0
#    protocol    = "-1"  # This means all protocols
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#}

resource "aws_ebs_volume" "dev" {
  availability_zone = "ap-south-1a"  # Change to your desired availability zone
  size              = 10

  # Optionally, you can tag the volume for better organization
  tags = {
    Name = "dev_volume"
  }
}


# Define the EC2 instance
resource "aws_instance" "dev" {
  ami           = "ami-0f58b397bc5c1f2e8"  # Change to your desired AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.test_subnet.id  
  associate_public_ip_address = true
  key_name	= "softradixad"
  root_block_device {
    volume_type           = "gp2"   # Change to your desired volume type
    volume_size           = 10      # Change to your desired volume size in GB
    delete_on_termination = true    # Whether to delete the volume on instance termination
  }
  availability_zone = "ap-south-1a" 
  vpc_security_group_ids = [aws_security_group.instance.id]
  user_data = <<EOF
#!/bin/bash
echo "Installing Nginx"
apt update
apt install nginx -y
systemctl enable --now nginx
echo "Hello from Dev">/var/www/html/index.html
EOF
  tags = {
    Name = "Dev-instance"
  }
}

resource "aws_volume_attachment" "dev" {
  device_name = "/dev/sdh"  # Change to the desired device name
  instance_id = aws_instance.dev.id
  volume_id   = aws_ebs_volume.dev.id
}


resource "aws_ebs_volume" "stage" {
  availability_zone = "ap-south-1a"  # Change to your desired availability zone
  size              = 10

  # Optionally, you can tag the volume for better organization
  tags = {
    Name = "stage_volume"
  }
}


resource "aws_instance" "stage" {
  ami           = "ami-0f58b397bc5c1f2e8"  # Change to your desired AMI
  instance_type = "t2.micro"
  associate_public_ip_address = true
  key_name      = "softradixad"
  subnet_id     = aws_subnet.test_subnet.id
  root_block_device {
    volume_type           = "gp2"   # Change to your desired volume type
    volume_size           = 10      # Change to your desired volume size in GB
    delete_on_termination = true    # Whether to delete the volume on instance termination
  }
  vpc_security_group_ids = [aws_security_group.instance.id]
  user_data = <<EOF
#!/bin/bash
echo "Installing Nginx"
apt update
apt install nginx -y
systemctl enable --now nginx
echo "Hello from stage">/var/www/html/index.html
EOF
  tags = {
    Name = "Stage-instance"
  }
}

resource "aws_volume_attachment" "stage" {
  device_name = "/dev/sdh"  # Change to the desired device name
  instance_id = aws_instance.stage.id
  volume_id   = aws_ebs_volume.stage.id
}

