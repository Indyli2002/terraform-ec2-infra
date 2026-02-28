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

resource "aws_instance" "public" {
  ami           = data.aws_ami.amazon_linux.id
  #ami                         = "ami-0f3caa1cf4417e51b" # find the AMI ID of Amazon Linux 2023  
  instance_type               = "t3.micro"
  subnet_id = data.aws_subnet.default_subnet.id
  #subnet_id                   = "subnet-0cc40215218f69c11"  #Public Subnet ID, e.g. subnet-xxxxxxxxxxx
  associate_public_ip_address = true
  key_name                    = "indy-ce12-key" #Change to your keyname, e.g. jazeel-key-pair
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
 
  tags = {
    Name = "indy-ec2"    #Prefix your own name, e.g. jazeel-ec2
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "indy-terraform-security-group" #Security group name, e.g. jazeel-terraform-security-group
  description = "Allow SSH inbound"
  vpc_id = data.aws_vpc.default.id
  #vpc_id      = "vpc-0d1d805038f7aad68"  #VPC ID (Same VPC as your EC2 subnet above), E.g. vpc-xxxxxxx
  tags = {
    Name = "indy-terraform-security-group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"  
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

