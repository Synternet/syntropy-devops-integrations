terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = ">= 2.4.0"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }

    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }

  }
  required_version = ">= 0.13"
}

provider "aws" {
  profile                 = "syntropy"
  region                  = "us-east-1"
  shared_credentials_file = "~/.aws/credentials"
  # alias   = "aws-east"
}

provider "digitalocean" {
  token = var.do_token
}

