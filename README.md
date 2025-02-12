# Terraform bootstrap

This repo creates an s3 bucket to store the terraform state and a dynamodb
table to store a lock for terraform to avoid concurrent plan/apply jobs.

## Setup a new AWS account

In most cases, you only need to create the S3 bucket and dynamodb table
once. The IAM user and access key to create those 2 components can be
deleted immediately after. You can't create it with the root user itself,
as that user only has access to IAM: it's not a full admin account.

To setup such a temporary user:

* Log in with the email address of the 'root user' of your AWS account
* At IAM -> Security credentials: create an access key, to create the IAM
  user which will have the rights to create the S3 and DynamoDB.
* Export those variables and run the script to create the temporary IAM user
  and show the access key ID and secret of that IAM user

```
cd temp-user-for-s3-and-dynamodb 
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
terraform init
terraform apply

terraform output -raw access_key_id
terraform output -raw secret_access_key
```

* Add a new environment in aws-terraform-bootstrap at https://github.com/openbraininstitute/aws-terraform-bootstrap/settings/environments
  containing the environment secrets AWS_ACCESS_KEY_ID and
  AWS_SECRET_ACCESS_KEY with the output.
  ⚠️ Watch out: drop the '%' at the end of printed key ID and secret: zsh
  has some issue when printing a newline.
* Run the Terraform Bootstrap action at https://github.com/openbraininstitute/aws-terraform-bootstrap/actions/workflows/terraform_bootstrap.yaml
  As environment, select the environment you just created.
* When the 'Terraform Bootstrap'
  You'll need to define a variable which will be used within the name of the
  S3 bucket and dynamodb table. Previously used names:
  * staging
  * production
  * sandbox-hpc
  * ecr
* Afterwards you can delete that IAM user and its access key for the
    creation of the S3 bucket and DynamoDB:

```
# again in temp-user-for-s3-and-dynamodb with same AWS_ACCESS_KEY_ID amd AWS_SECRET_ACCESS_KEY
# environment variables

terraform destroy
```

* You can now delete that access key owned by the root user of your AWS
  account at IAM -> Manage access keys.


# Funding and Acknowledgement

Copyright (c) 2025 Open Brain Institute
 
