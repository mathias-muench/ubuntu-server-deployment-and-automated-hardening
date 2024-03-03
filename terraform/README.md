# Terraform

## Create infrastructure

The terraform setup should run on any AWS account with a simple

    terraform apply

Access to the account via credential file or environment variable is
necessary.

The public DNS name to reach the instance is needed in the ansible step.
Find it with

    terraform state show aws_eip.external

## Remarks

From [Code structure - Terraform Best Practices][]: “Putting all code in
main.tf is a good idea when you are getting started or writing an
example code.” So this terraform setup is expected to be the simplest
thing that could possibly work.

The completely open security group is quite unusual. It is done like
this to be able to test the securing of the server with Linux tools.

  [Code structure - Terraform Best Practices]: https://www.terraform-best-practices.com/code-structure
