# Terraform 101
## A Slalom Terraform Lab

### Table of Contents
* [Pre-requisities](#pre-requisites)
* [The Basics - Common Terraform Commands](#the-basics---comomon-terraform-commands)

---

### Pre-requisites
In order to complete this lab you will need the following tools installed and configured:
* [git](https://git-scm.com/downloads)
* [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) (with valid AWS credentials configured)
* [terraform](https://learn.hashicorp.com/terraform/getting-started/install.html)

---

### The Basics - Comomon Terraform Commands
Terraform provides many different commands to run for various purposes, but when running Terraform you will generally primarily find yourself using these 3 commands.

The First Command:
```
terraform init
```
This command is used to "initialize" terraform in the working directory that you are using terraform code. If you clone terraform code from source control and have never ran the code before, you should run this command first. Additionally, if you are starting a new folder where you would like to run terraform code, you should run this commmand before executing any other terraform commands.

The Second Command:
```
terraform plan
```
The purpose of the terraform plan command is to see a summary of the changes that will occur uppon running terraform.

The Third Command:
```
terraform apply
```
The purpose of the terraform apply command is to execute terraform, this command will run terraform and apply the configuration from your local terraform files to AWS. It is important to run a terraform plan before running this command to avoid accidental changes to existing resources you previously created with terraform.

For a full list of Terraform commannds that are available you can check their documentation [here](https://www.terraform.io/docs/commands/init.html), or run the following command:
```
terraform --help
```

---