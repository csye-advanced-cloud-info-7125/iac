terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.33.0"
    }
  }
}

provider "aws" {
  region = var.region
  # profile = var.prodProfile
}

# required_providers {
#     aws = {
#       "configuration_aliases" = [aws.kops]
#       "source"                = "hashicorp/aws"
#       "version"               = "4.33.0"
#     }
#   }

# provider "aws" {
#   alias   = "kops"
#   region  = var.region
#   profile = var.profile
# }
