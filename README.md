# Wild Rydes Terraform
![Wild Rydes](wildrydes-homepage.png)

## Description
This repository contains Terraform code to manage a provision infrastructure related to Amazon Web Service's "Build a Serverless Web Application". The tutorial can be found here: https://aws.amazon.com/getting-started/projects/build-serverless-web-app-lambda-apigateway-s3-dynamodb-cognito/?trk=gs_card

## Requirements
* [Terraform](https://www.terraform.io/downloads.html) 0.12.x

## Creating Wild Rydes Serverless Web Application

* Export AWS credentials into environment variables
* Apply Terraform

```
terraform init
terraform apply --var-file=variables.tfvar
```

## Delete Wild Rydes Serverless Web Application
* Export AWS credentials into environment variables
* Destroy Terraform configuration

```
terraform destrory --var-file=variables.tfvar
```
        