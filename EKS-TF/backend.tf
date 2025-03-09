terraform {
  backend "s3" {
    bucket         = "my-bakett22"
    region         = "us-east-1"
    key            = "End-to-End-Kubernetes-DevSecOps-Resume-Project/EKS-TF/terraform.tfstate"
    encrypt        = true
    use_lockfile = true
  }
  required_version = ">=0.13.0"
  required_providers {
    aws = {
      version = ">= 2.7.0"
      source  = "hashicorp/aws"
    }
  }
}