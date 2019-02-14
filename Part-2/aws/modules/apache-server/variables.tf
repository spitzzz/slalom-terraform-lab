variable "region" {
    description = "The AWS region to create resources in."
}

variable "instance-type" {
    description = "The ec2 instance type to use for the Apache web server."
}

variable "vpc-id" {
    description = "The id of the VPC to create the webserver security group in."
}

variable "subnet-id" {
    description = "The id of the subnet to put the ec2 instance into."
}

variable "key-pair-name" {
    description = "The name of the SSH keypair to create for the web server ec2 instance to use."
}