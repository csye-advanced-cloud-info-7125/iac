data "aws_vpc" "requestorvpc" {
  # provider = aws.cluster_region
  filter {
    name   = "tag:Name"
    values = ["cluster-vpc"]
  }
}

# data "aws_route_table" "requestor_rtb" {
#   provider = aws.cluster_region
#   vpc_id   = data.aws_vpc.requestorvpc.id
#   filter {
#     name   = "tag:Name"
#     values = ["private-*-${var.cluster_name}-${var.domain}"]
#   }
# }
data "aws_route_tables" "requestor_rtb" {
  # provider = aws.cluster_region
  vpc_id = data.aws_vpc.requestorvpc.id
  filter {
    name   = "tag:Name"
    values = ["private-*.${var.cluster_name}.${var.domain}"]
  }
}

data "aws_security_group" "acceptor-node-sg" {
  # provider = aws.cluster_region
  vpc_id = data.aws_vpc.requestorvpc.id
  filter {
    name   = "tag:Name"
    values = ["nodes.${var.cluster_name}.${var.domain}"]
  }
}
locals {
  accsg = data.aws_security_group.acceptor-node-sg.id
}


# create vpc
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc-cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.vpcName}-vpc"
  }
}

# create internet gateway and attach it to vpc
# resource "aws_internet_gateway" "internet_gateway" {
#   vpc_id    = aws_vpc.vpc.id

#   tags      = {
#     Name    = "${}-igw"
#   }
# }

# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}

# create public subnet az1
# resource "aws_subnet" "public_subnet_az1" {
#   vpc_id                  = aws_vpc.vpc.id
#   cidr_block              = var.public-subnet1-cidr
#   availability_zone       = data.aws_availability_zones.available_zones.names[0]
#   map_public_ip_on_launch = true

#   tags      = {
#     Name    = "${var.vpcName}-public-subnet1-${data.aws_availability_zones.available_zones.names[0]}"
#   }
# }

# # create public subnet az2
# resource "aws_subnet" "public_subnet_az2" {
#   vpc_id                  = aws_vpc.vpc.id
#   cidr_block              = var.public-subnet2-cidr
#   availability_zone       = data.aws_availability_zones.available_zones.names[1]
#   map_public_ip_on_launch = true

#   tags      = {
#     Name    = "${var.vpcName}-public-subnet2-${data.aws_availability_zones.available_zones.names[1]}"
#   }
# }

# create route table and add public route
# resource "aws_route_table" "public_route_table" {
#   vpc_id       = aws_vpc.vpc.id

#   route {
#     cidr_block = 
#     gateway_id = 
#   }

#   tags       = {
#     Name     = 
#   }
# }

# associate public subnet az1 to "public route table"
# resource "aws_route_table_association" "public_subnet_az1_route_table_association" {
#   subnet_id           = 
#   route_table_id      = 
# }

# # associate public subnet az2 to "public route table"
# resource "aws_route_table_association" "public_subnet_az2_route_table_association" {
#   subnet_id           = 
#   route_table_id      = 
# }

# create private data subnet az1
resource "aws_subnet" "private_data_subnet_az1" {
  depends_on = [
    aws_vpc.vpc
  ]
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private-subnet1-cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.vpcName}-privateSubnet1-${data.aws_availability_zones.available_zones.names[0]}"
  }
}

# create private data subnet az2
resource "aws_subnet" "private_data_subnet_az2" {
  depends_on = [
    aws_vpc.vpc
  ]
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private-subnet2-cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.vpcName}-privateSubnet1-${data.aws_availability_zones.available_zones.names[1]}"
  }
}

# create private data subnet az3
resource "aws_subnet" "private_data_subnet_az3" {
  depends_on = [
    aws_vpc.vpc
  ]
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private-subnet3-cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[2]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.vpcName}-privateSubnet1-${data.aws_availability_zones.available_zones.names[1]}"
  }
}

resource "aws_route_table" "private-subnet-route-table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Route-Table-For-Private-Subnets"
  }
}

resource "aws_route_table_association" "private_data_subnet_az1_association" {
  subnet_id      = aws_subnet.private_data_subnet_az1.id
  route_table_id = aws_route_table.private-subnet-route-table.id
}

resource "aws_route_table_association" "private_data_subnet_az2_association" {
  subnet_id      = aws_subnet.private_data_subnet_az2.id
  route_table_id = aws_route_table.private-subnet-route-table.id
}

resource "aws_route_table_association" "private_data_subnet_az3_association" {
  subnet_id      = aws_subnet.private_data_subnet_az3.id
  route_table_id = aws_route_table.private-subnet-route-table.id
}

resource "aws_vpc_peering_connection" "clusterVpc-to-awsVpc" {
  depends_on = [
    aws_vpc.vpc
  ]
  peer_vpc_id = data.aws_vpc.requestorvpc.id
  vpc_id      = aws_vpc.vpc.id
  peer_region = var.clusterregion
  tags = {
    "Name" = "clusterVpc-to-awsVpc-Peering"
  }
}

resource "aws_vpc_peering_connection_accepter" "accept" {
  # provider = aws.cluster_region
  depends_on = [
    aws_vpc_peering_connection.clusterVpc-to-awsVpc
  ]
  auto_accept               = true
  vpc_peering_connection_id = aws_vpc_peering_connection.clusterVpc-to-awsVpc.id
}

# ### Requestor route
# resource "aws_route" "requestor_route" {
#   route_table_id            = data.aws_route_table.requestor_rtb.id
#   destination_cidr_block    = var.requestor_cidr_block
#   vpc_peering_connection_id = aws_vpc_peering_connection.clusterVpc-to-awsVpc.id
# }
# ### Accepter route
# resource "aws_route" "accepter_route" {
#   route_table_id            = aws_route_table.private-subnet-route-table.id
#   destination_cidr_block    = var.requestor_cidr_block
#   vpc_peering_connection_id = aws_vpc_peering_connection.clusterVpc-to-awsVpc.id
# }


### Accepter route
resource "aws_route" "accepter_route" {

  depends_on = [
    aws_vpc.vpc, aws_vpc_peering_connection.clusterVpc-to-awsVpc
  ]
  route_table_id            = aws_route_table.private-subnet-route-table.id
  destination_cidr_block    = data.aws_vpc.requestorvpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.clusterVpc-to-awsVpc.id
  # count                     = length(data.aws_route_tables.requestor_rtb.ids)
  # route_table_id            = data.aws_route_tables.requestor_rtb.ids[count.index]
  # destination_cidr_block    = aws_vpc.vpc.cidr_block
  # vpc_peering_connection_id = aws_vpc_peering_connection.clusterVpc-to-awsVpc.id
}

### Requestor route
resource "aws_route" "requestor_route" {
  depends_on = [
    aws_vpc_peering_connection.clusterVpc-to-awsVpc
  ]
  # provider = aws.cluster_region
  # route_table_id            = aws_route_table.private-subnet-route-table.id
  # destination_cidr_block    = data.aws_vpc.requestorvpc.cidr_block
  # vpc_peering_connection_id = aws_vpc_peering_connection.clusterVpc-to-awsVpc.id
  count                     = length(data.aws_route_tables.requestor_rtb.ids)
  route_table_id            = data.aws_route_tables.requestor_rtb.ids[count.index]
  destination_cidr_block    = aws_vpc.vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.clusterVpc-to-awsVpc.id
}



#RDS Instance:
resource "aws_security_group" "postgres-rds" {
  # provider = aws.cluster_region

  name = "Postgres-rds"

  description = "RDS postgres servers (terraform-managed)"
  vpc_id      = aws_vpc.vpc.id
  # Only postgres in
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = ["${data.aws_security_group.acceptor-node-sg.id}"]
  }
}

resource "aws_db_subnet_group" "postgres_database_subnet_group" {
  name        = "rds-${aws_vpc.vpc.id}-private-subnet-group"
  description = "Subnet group for RDS PostgreSQL instance."
  subnet_ids  = ["${aws_subnet.private_data_subnet_az1.id}", "${aws_subnet.private_data_subnet_az2.id}", "${aws_subnet.private_data_subnet_az3.id}"]

  tags = {
    Name = "db-subnet-group-For-RDS"
  }
}

resource "aws_db_parameter_group" "rds-param-grp" {
  name   = "postgres-rds-param-group"
  family = "postgres14"
  parameter {
    name  = "shared_preload_libraries"
    value = "pg_stat_statements"
  }
}
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "kms-key-policys" {
  statement {
    sid       = "Enable IAM User Permissions"
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }

  # statement {
  #   sid       = "Allow access for Key Administrators"
  #   effect    = "Allow"
  #   actions   = ["kms:*"]
  #   resources = ["*"]

  #   principals {
  #     type = "AWS"
  #     identifiers = [
  #       "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${data.aws_caller_identity.current.user_id}",
  #       "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/support.amazonaws.com/AWSServiceRoleForSupport",
  #       "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/trustedadvisor.amazonaws.com/AWSServiceRoleForTrustedAdvisor"
  #     ]
  #   }
  # }

  # statement {
  #   sid    = "Allow use of the key"
  #   effect = "Allow"
  #   actions = [
  #     "kms:Encrypt",
  #     "kms:Decrypt",
  #     "kms:ReEncrypt*",
  #     "kms:GenerateDataKey*",
  #     "kms:DescribeKey"
  #   ]
  #   resources = ["*"]

  #   principals {
  #     type = "AWS"
  #     identifiers = [
  #       "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/rds.amazonaws.com/AWSServiceRoleForRDS"
  #     ]
  #   }
  # }

  # statement {
  #   sid    = "Allow attachment of persistent resources"
  #   effect = "Allow"
  #   actions = [
  #     "kms:CreateGrant",
  #     "kms:ListGrants",
  #     "kms:RevokeGrant"
  #   ]
  #   resources = ["*"]

  #   principals {
  #     type = "AWS"
  #     identifiers = [
  #       "arn:aws:iam::${local.account_id}:user/${local.admin_username}",
  #       "arn:aws:iam::${local.account_id}:role/aws-service-role/support.amazonaws.com/AWSServiceRoleForSupport",
  #       "arn:aws:iam::${local.account_id}:role/aws-service-role/trustedadvisor.amazonaws.com/AWSServiceRoleForTrustedAdvisor"
  #     ]
  #   }

  #   condition {
  #     test     = "Bool"
  #     variable = "kms:GrantIsForAWSResource"
  #     values   = ["true"]
  #   }
  # }
}

resource "aws_kms_key" "rds_kms_key" {
  description              = "My KMS Keys for Data Encryption"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"

  tags = {
    Name = "rds_kms_key"
  }

  policy = data.aws_iam_policy_document.kms-key-policys.json
}

resource "aws_kms_alias" "rds_kms_alias" {
  target_key_id = aws_kms_key.rds_kms_key.key_id
  name          = "alias/rds-kms"
}

resource "aws_db_instance" "postgresDB" {
  allocated_storage       = 200 # gigabytes
  backup_retention_period = 7   # in days
  db_subnet_group_name    = aws_db_subnet_group.postgres_database_subnet_group.id
  engine                  = "postgres"
  engine_version          = "14.4"
  identifier              = "db"
  instance_class          = "db.t3.micro"
  multi_az                = false
  db_name                 = "postgresdb"
  username                = "postgres"
  password                = var.rds_password
  port                    = 5432
  kms_key_id              = aws_kms_alias.rds_kms_alias.arn
  storage_encrypted       = true # you should always do this
  storage_type            = "gp2"
  # deletion_protection     = false
  skip_final_snapshot    = true
  availability_zone      = data.aws_availability_zones.available_zones.names[0]
  parameter_group_name   = aws_db_parameter_group.rds-param-grp.id
  vpc_security_group_ids = ["${aws_security_group.postgres-rds.id}"]
}

