terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

variable "cluster_name" {
  default = "dongseok-test"
}

variable "cluster_version" {
  default = "1.28"
}