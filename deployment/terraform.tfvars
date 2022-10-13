# ssh_public_key = "~/.ssh/gcpkey.pub"

# # uncomment for deploymnet in us-east-1 region
# # zones          = [us-east-1a, us-east-1b, us-east-1c]
# region         = "us-east-1"
# instance_image = "ami-08c40ec9ead489470"

# # uncomment for deploymnet in us-west-2 region
# # zones          = "us-west-2a,us-west-2b,us-west-2c"
# # region         = "us-west-2"
# # instance_image = "ami-017fecd1353bcc96e"


# master_size = "t2.medium"
# node_size   = "t2.micro"

# kops_iam_username = "kops_user"

# cluster_name = "kopscluster"

region               = "us-west-2"
clusterregion        = "us-east-1"
vpc-cidr             = "10.0.0.0/16"
private-subnet1-cidr = "10.0.1.0/24"
private-subnet2-cidr = "10.0.2.0/24"
private-subnet3-cidr = "10.0.3.0/24"
cluster_name         = "kopscluster"
vpcName              = "aws-vpc"
