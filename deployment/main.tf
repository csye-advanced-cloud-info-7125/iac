module "kops" {
  source = "../modules/awsVpc"

  region               = var.region
  clusterregion        = var.clusterregion
  vpc-cidr             = var.vpc-cidr
  private-subnet1-cidr = var.private-subnet1-cidr
  private-subnet2-cidr = var.private-subnet2-cidr
  private-subnet3-cidr = var.private-subnet3-cidr
  cluster_name         = var.cluster_name
  vpcName              = "aws"
  domain               = var.domain
  rds_password         = var.rds_password

  # region                          = var.region
  # zones                           = var.zones
  # policies                        = var.policies
  # kops_iam_username               = var.kops_iam_username
  # kops_state_store_s3_bucket_name = var.kops_state_store_s3_bucket_name
  # # profile                         = var.prodProfile
  # # master_size                     = var.master_size
  # # node_size                       = var.node_size
  # ssh_public_key = var.ssh_public_key
  # # instance_image                  = var.instance_image
  # cluster_name = var.cluster_name
  # domain       = var.domain

}

# module "clusternetwork" {
#   source                          = "../modules/cluster_network"
#   region                          = var.region
#   zones                           = var.zones
#   master_size                     = var.master_size
#   node_size                       = var.node_size
#   ssh_public_key                  = var.ssh_public_key
#   instance_image                  = var.instance_image
#   cluster_name                    = var.cluster_name
#   domain                          = var.domain
#   kops_state_store_s3_bucket_name = module.kops.kops_s3_bucket_name
#   zoneid                          = var.zoneid
#   kops_iam_username               = var.kops_iam_username

#   # providers = {
#   #   aws = aws.kops
#   # }
#   # profile                         = var.profile

# }

