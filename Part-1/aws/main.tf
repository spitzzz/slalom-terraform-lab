provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  enable_dns_support   = "true"
  enable_dns_hostnames = "true" 

  tags {
    Name                = "Terraform 101 Workshop - VPC"
  }
}

resource "aws_internet_gateway" "internet-gateway" {
  count  = "1"
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name                = "Terraform 101 Internet Gateway"
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.internet-gateway.id}"
}

resource "aws_subnet" "public-subnet1" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"

  tags {
    Name                = "Terraform 101 Public Subnet #1"
  }
}

resource "aws_subnet" "public-subnet2" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"
  tags {
    Name                = "Terraform 101 Public Subnet #2"
  }
}

resource "aws_subnet" "private-subnet" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "10.0.16.0/20"
  map_public_ip_on_launch = "false"
  availability_zone = "us-east-1c"

  tags {
    Name                = "Terraform 101 Private Subnet"
  }
}

resource "aws_eip" "natip" {
  vpc = true
  depends_on = ["aws_internet_gateway.internet-gateway"]
  tags {
    Name                = "Terraform 101 NAT IP"
  }
}

resource "aws_nat_gateway" "internet" {
  allocation_id = "${aws_eip.natip.id}"
  subnet_id = "${aws_subnet.private-subnet.id}"
  depends_on = ["aws_internet_gateway.internet-gateway", "aws_eip.natip", "aws_subnet.private-subnet"]

  tags {
    Name                = "Terraform 101 NAT Gateway"
  }
}

resource "aws_route_table" "table" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name                = "Terraform 101 VPC Route Table"
  }
}

resource "aws_route" "private_route_internet_connection_through_nat" {
  route_table_id = "${aws_route_table.table.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.internet.id}"
}

resource "aws_route_table_association" "private_subnet_association" {
  subnet_id = "${aws_subnet.private-subnet.id}"
  route_table_id = "${aws_route_table.table.id}"
}

resource "aws_route_table_association" "public_subnet1_association" {
  subnet_id = "${aws_subnet.public-subnet1.id}"
  route_table_id = "${aws_vpc.vpc.main_route_table_id}"
}

resource "aws_route_table_association" "public_subnet2_association" {
  subnet_id = "${aws_subnet.public-subnet2.id}"
  route_table_id = "${aws_vpc.vpc.main_route_table_id}"
}


# Get the AWS Ubuntu image
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

# Create security group with web and ssh access
resource "aws_security_group" "web_server" {
  name = "Terraform 101 Webserver Security Group"
  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  depends_on = ["aws_vpc.vpc"]
}

# Deploy ssh key for instance access
resource "aws_key_pair" "deployer" {
  key_name = "Terraform-101-KeyPair" 
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

# Create web server
resource "aws_instance" "web_server" {
    ami = "${data.aws_ami.ubuntu.id}"
    vpc_security_group_ids = ["${aws_security_group.web_server.id}"]
    subnet_id = "${aws_subnet.public-subnet1.id}"
    instance_type = "t2.micro"
    key_name      = "Terraform-101-KeyPair"
    tags {
        Name = "Terraform 101 Workshop Web Server"
    }

  connection {
    user         = "ubuntu"
    private_key  = "${file("~/.ssh/id_rsa")}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install apache2 -y",
      "sudo systemctl enable apache2",
      "sudo systemctl start apache2",
      "sudo chmod 777 /var/www/html/index.html"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod 644 /var/www/html/index.html"
    ]
  }

  # Save the public IP for testing
  provisioner "local-exec" {
    command = "echo ${aws_instance.web_server.public_ip} > public-ip.txt"
  }

}

output "public_ip" {
  value = "${aws_instance.web_server.public_ip}"
}