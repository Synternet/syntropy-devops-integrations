terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 1.22.2"
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
}

provider "aws" {
  profile                 = "syntropy"
  region                  = "us-east-1"
  shared_credentials_file = "~/.aws/credentials"
  # alias   = "aws-east"
}

