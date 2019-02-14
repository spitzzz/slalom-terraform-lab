# Terraform 101
## A Slalom Terraform Lab

### Navigation
* [Part 1 - Executing "raw" Terraform](/Part-1)
* [Part 2 - Making your first Terraform Module](/Part-2)

---

### Pre-requisites
* [git](https://git-scm.com/downloads)
* [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) (with valid AWS credentials configured)
* [terraform](https://learn.hashicorp.com/terraform/getting-started/install.html)

You will need to have the above tools installed and configured with valid credentials before attempting to follow this lab to create resources using terraform.

---

### Getting Started
It is recommended that you clone down this code from this repository using `git` or simply download this repo as a zip file onto your machine. If you would like to run the terraform files in this repo, they will need to be on your local machine. Additionally, you will need to have all of the pre-requisites installed and configured as mentioned above.

---

### The Basics - Common Terraform Commands
Terraform provides many different commands to run for various purposes, but when running Terraform you will generally primarily find yourself using these 4 commands.

The First Command:
```
terraform init
```
This command is used to "initialize" terraform in the working directory that you are using terraform code. If you clone terraform code from source control and have never ran the code before, you should run this command first. Additionally, if you are starting a new folder where you would like to run terraform code, you should run this command before executing any other terraform commands.

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

The Fourth Command:
```
terraform destroy
```
As you might have guessed, the purpose of this command is to destroy what you have created, by running this command terraform will check your state file (which was a file created by terraform apply we will discuss later), and then delete the resources that are defined in your state file from AWS, once deleted, it will respectively remove that resource from the state file.

For a full list of Terraform commands that are available you can check their documentation [here](https://www.terraform.io/docs/commands/init.html), or run the following command:
```
terraform --help
```

---