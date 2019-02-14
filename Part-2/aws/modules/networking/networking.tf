provider "aws" {
  region = "${var.region}"
}

resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr_range}"

  enable_dns_support   = "true"
  enable_dns_hostnames = "true" 

  tags {
    Name                = "${var.vpc_name}"
  }
}

resource "aws_internet_gateway" "internet-gateway" {
  count  = "1"
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name                = "${var.vpc_name} Internet Gateway"
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.internet-gateway.id}"
}

resource "aws_subnet" "public-subnet1" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.public_subnet1_cidr_range}"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"

  tags {
    Name                = "${var.vpc_name} Public Subnet #1"
  }
}

resource "aws_subnet" "public-subnet2" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.public_subnet2_cidr_range}"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"
  tags {
    Name                = "${var.vpc_name} Public Subnet #2"
  }
}

resource "aws_subnet" "private-subnet" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "10.0.16.0/20"
  map_public_ip_on_launch = "false"
  availability_zone = "us-east-1c"

  tags {
    Name                = "${var.vpc_name} Private Subnet"
  }
}

resource "aws_eip" "natip" {
  vpc = true
  depends_on = ["aws_internet_gateway.internet-gateway"]
  tags {
    Name                = "${var.vpc_name} NAT IP"
  }
}

resource "aws_nat_gateway" "internet" {
  allocation_id = "${aws_eip.natip.id}"
  subnet_id = "${aws_subnet.private-subnet.id}"
  depends_on = ["aws_internet_gateway.internet-gateway", "aws_eip.natip", "aws_subnet.private-subnet"]

  tags {
    Name                = "${var.vpc_name} NAT Gateway"
  }
}

resource "aws_route_table" "table" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name                = "${var.vpc_name} VPC Route Table"
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