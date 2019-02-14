module "networking" {
  source  = "./modules/networking"

  # Input Parameters
  region = "us-east-1"
  vpc_name = "Terraform 101 Workshop"
  vpc_cidr_range = "10.0.0.0/16"
  public_subnet1_cidr_range = "10.0.1.0/24"
  public_subnet2_cidr_range = "10.0.2.0/24"
  private_subnet_cidr_range = "10.0.16.0/20"
}

module "apache-server" {
  source  = "./modules/apache-server"

  # Input Parameters
  region = "us-east-1"
  instance-type = "t2.micro"
  subnet-id = "${module.networking.public-subnet1-id}"
  vpc-id = "${module.networking.vpc-id}"
  key-pair-name = "terraform-101-keypair-slalomworkshop"
}
