# Terraform 101
## A Slalom Terraform Lab

### Table of Contents
* [Pre-requisities](#pre-requisites)
* [The Basics - Common Terraform Commands](#the-basics)

---

### Pre-requisites
In order to complete this lab you will need the following tools installed and configured:
* [git](https://git-scm.com/downloads)
* [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) (with valid AWS credentials configured)
* [terraform](https://learn.hashicorp.com/terraform/getting-started/install.html)

---

### The Basics
When running Terraform you will generally primarily find yourself using 3 commands.

The First Command:
```
terraform init
```
This command is used to "initialize" terraform in the working directory that you are using terraform code. If you clone terraform code from source control and have never ran the code before, you should run this command first. Additionally, if you are starting a new folder where you would like to run terraform code, you should run this commmand before executing any other terraform commands.

The Second Command:
```
terraform plan
```

The Third Command:
```
terraform apply
```

---