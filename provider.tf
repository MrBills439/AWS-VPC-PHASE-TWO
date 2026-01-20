terraform {
    requried_providers {
        aws = {
            sourece = "hashicorp/aws"
            version = "5.0.1"
        }
    }
}

provider "aws" {
    region = "us-east-1"
}