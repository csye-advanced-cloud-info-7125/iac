# variable "region" {
#   type        = string
#   description = "AWS region"
# }

# variable "zones" {
#   default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
#   type        = list(string)
#   description = "AWS zones to deploy kops cluster"
# }

# variable "kops_iam_username" {
#   type        = string
#   description = "kops IAM user name"
# }

# variable "policies" {
#   default = [
#     "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
#     "arn:aws:iam::aws:policy/AmazonRoute53FullAccess",
#     "arn:aws:iam::aws:policy/AmazonS3FullAccess",
#     "arn:aws:iam::aws:policy/IAMFullAccess",
#     "arn:aws:iam::aws:policy/AmazonVPCFullAccess",
#     "arn:aws:iam::aws:policy/AmazonSQSFullAccess",
#     "arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess",
#   ]
#   type        = list(string)
#   description = "List of policy attached to kops IAM user"
# }

# variable "cluster_name" {
#   type        = string
#   description = "Name of the cluster"
# }

# variable "kops_state_store_s3_bucket_name" {
#   type        = string
#   description = "S3 bucket name for kops state store"
# }

# variable "master_size" {
#   type        = string
#   description = "Instance size for master node"
# }

# variable "node_size" {
#   type        = string
#   description = "Instance size for worker node"
# }

# variable "ssh_public_key" {
#   type        = string
#   description = "SSH public key path"
# }

# variable "domain" {
#   type        = string
#   description = "Domain name for kops cluster"
# }

# variable "instance_image" {
#   type        = string
#   description = "Image for kops cluster"
# }
# variable "zoneid" {
#   type        = string
#   description = "provide the zoneid of the "
# }

# variable "prodProfile" {
#   default     = "prod"
#   type        = string
#   description = "Profile to use for creating S3 and IAM"
# }
# variable "profile" {
#   default     = "kops_user"
#   type        = string
#   description = "Profile to use for creating cluster"
# }


#awsVPC:
variable "region" {}
variable "clusterregion" {}
variable "vpc-cidr" {}
variable "private-subnet1-cidr" {}
variable "private-subnet2-cidr" {}
variable "private-subnet3-cidr" {}
variable "cluster_name" {}
variable "domain" {}
variable "vpcName" {}
variable "rds_password" {}
#------------------
