# Terraform 101
## Part 1 - Executing "raw" Terraform

### Navigation
* [Home](../)
* [Part 1 - Executing "raw" Terraform](/Part-1)
* [Part 2 - Making your first Terraform Module](/Part-2)

---

#### Introduction

Hello!

In this section we will execute what I like to call "raw" terraform without any modules or complexities. We will only have one terraform file which will contain our terraform code and all of its configuration directly within it. Spliitting out configuration will start to make more sense when we hit [Part 2](/Part-2)

---

#### Resources to be Created
* VPC
* 3 Subnets (1 Private, 2 Public)
* An Internet Gateway (this will allows our subnets to have the ability to obtain internet access)
* A NAT Gateway (this will allow our private subnet access to the internet)
* A Route Table
* Routes in the Route Table
* t2.micro EC2 instance running an apache web server in one of the public subnets
* Security Group for our web server

---

#### How to Run

Change directories into this folder `Part-1/aws`

Please ensure you have all of the Pre-Requisites mentioned in the [Home Readme](../) before continuing.

**Step 1:**

Run `terraform plan` to see review the changes before running them, this is a best practice to avoid the mistaken creation or deletion of resources.

```
terraform plan
```

**Step 2:**

Run `terraform apply` to apply the changes that the plan command above said that it was going to create or change. After running this command you will then have to type `yes` to confirm.

```
terraform apply
```

Assuming you have valid AWS credentials that have access to create all of the resources listed in `main.tf` terraform will now begin to create all of these resources in your AWS account.

**Clean up**

Once you are finished, you should run a `terraform destroy` to delete all of the resources you created. You wlil once again be prompted to type `yes` to confirm your changes.

```
terraform destroy
```

#### Moving On...

Now that we have some basic knowledge of how Terraform works, lets move on to making our first Terraform module in [Part 2](/Part-2).