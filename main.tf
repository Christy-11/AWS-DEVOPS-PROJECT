provider "aws" {
  region = "ap-south-1" # Update this to your AWS region if different
}

resource "aws_instance "app_server" {
  ami           = "ami-053b12d3152ef14d7" # Standard Ubuntu AMI (update if needed)
  instance_type = "t2.micro"

  tags = {
    Name = "Flask-DevOps-EC2"
  }
}