#get default VPC
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "default_subnet" {
  default_for_az = true
  availability_zone = "ap-southeast-1a"
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}