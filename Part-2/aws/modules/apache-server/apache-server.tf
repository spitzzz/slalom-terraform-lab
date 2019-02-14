provider "aws" {
  region = "${var.region}"
}

# Create web server
resource "aws_instance" "web_server" {
    ami = "${data.aws_ami.ubuntu.id}"
    vpc_security_group_ids = ["${aws_security_group.web_server.id}"]
    subnet_id = "${var.subnet-id}"
    instance_type = "${var.instance-type}"
    key_name      = "${var.key-pair-name}"
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
  vpc_id = "${var.vpc-id}"

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

}

# Deploy ssh key for instance access
resource "aws_key_pair" "deployer" {
  key_name = "${var.key-pair-name}" 
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}