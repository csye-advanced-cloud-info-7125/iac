variable "region" {
  default     = "us-east-1"
  type        = string
  description = "AWS region"
}

variable "zones" {
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
  type        = list(string)
  description = "AWS zones to deploy kops cluster"
}

variable "kops_iam_username" {
  default     = "kops_user"
  type        = string
  description = "kops IAM user name"
}

variable "policies" {
  default = [
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AmazonRoute53FullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/IAMFullAccess",
    "arn:aws:iam::aws:policy/AmazonVPCFullAccess",
    "arn:aws:iam::aws:policy/AmazonSQSFullAccess",
    "arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess",
  ]
  type        = list(string)
  description = "List of policy attached to kops IAM user"
}

variable "cluster_name" {
  default     = "kopscluster"
  type        = string
  description = "Name of the cluster"
}

variable "kops_state_store_s3_bucket_name" {
  type        = string
  description = "S3 bucket name for kops state store"
}

variable "ssh_public_key" {
  default     = "~/.ssh/gcpkey.pub"
  type        = string
  description = "SSH public key path"
}

variable "domain" {
  type        = string
  description = "Domain name for kops cluster"
}

variable "master_size" {
  type        = string
  default     = "t2.medium"
  description = "Instance size for master node"
}

variable "node_size" {
  type        = string
  default     = "t2.micro"
  description = "Instance size for worker node"
}

variable "instance_image" {
  type        = string
  default     = "ami-08c40ec9ead489470"
  description = "Image for kops cluster"
}
