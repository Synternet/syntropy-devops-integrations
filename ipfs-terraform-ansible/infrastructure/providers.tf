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
  required_version = ">= 0.13, < 0.14"
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

provider "google" {
  project     = var.app_project
  credentials = file(var.gcp_auth_file)
  region      = var.gcp_region_1
  zone        = var.gcp_zone_1
}

