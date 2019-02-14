# Terraform 101
## Part 2 - Making your first Terraform Module

### Navigation
* [Home](../)
* [Part 1 - Executing "raw" Terraform](/Part-1)
* [Part 2 - Making your first Terraform Module](/Part-2)

---

#### Introduction

Hello!

In this section we will create the same infrastructure we created in [Part 1](/Part-1), but now we will split out our Terraform code into [Terraform Modules](https://www.terraform.io/docs/modules/usage.html).

Take a look into `main.tf` to see how the same code we used in Part 1 has now been broken up into two different terraform modules, one called `networking`, which creates all of the networking related resources (VPC, subnets, internet gateway, nat gateway, etc.) while the other is an `apache-server` module that is used for simply creating an apache webserver on an AWS EC2 instance. Note how we can pass in parameters to this module and it will install an apache webserver with whatever configuration we'd like.

---

#### How to Run

Change directories into this folder `Part-2/aws`

Please ensure you have all of the Pre-Requisites mentioned in the [Home Readme](../) before continuing.

The commands to run Part 2 are the same as in Part 1! The main difference here is the structure of our code, which was created using terraform modules.

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
