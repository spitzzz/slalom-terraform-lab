variable "region" {
    description = "The AWS region to create resources in."
}

variable "vpc_cidr_range" {
    description = "The CIDR range of the VPC."
}

variable "public_subnet1_cidr_range" {
    description = "The CIDR range for Public Subnet 1."
}

variable "public_subnet2_cidr_range" {
    description = "The CIDR range for Public Subnet 2."
}

variable "private_subnet_cidr_range" {
    description = "The CIDR range for the Private Subnet."
}

variable "vpc_name" {
    description = "The name of the VPC."
}