resource "aws_s3_bucket" "kops_state" {
  bucket        = var.kops_state_store_s3_bucket_name
  force_destroy = true

  tags = {
    Application = "kops"
    Description = "S3 Bucket for KOPS state"
  }
}

resource "aws_s3_bucket_acl" "acl" {
  bucket = aws_s3_bucket.kops_state.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.kops_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "versioning-bucket-config" {
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.versioning]

  bucket = aws_s3_bucket.kops_state.bucket

  rule {
    id = "config"

    filter {
      prefix = "config/"
    }

    noncurrent_version_expiration {
      noncurrent_days = 90
    }

    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "STANDARD_IA"
    }

    noncurrent_version_transition {
      noncurrent_days = 60
      storage_class   = "GLACIER"
    }

    status = "Enabled"
  }
}

resource "aws_iam_user" "kops_iam_user" {
  name = var.kops_iam_username
}

resource "aws_iam_access_key" "kops_iam_user_access_key" {
  user       = aws_iam_user.kops_iam_user.name
  depends_on = [aws_iam_user.kops_iam_user]
}

resource "aws_iam_user_login_profile" "kops_iam_user_profile" {
  user       = aws_iam_user.kops_iam_user.name
  depends_on = [aws_iam_user.kops_iam_user]
}

resource "aws_iam_policy_attachment" "kops_iam_user_policy" {
  name       = "kops_iam_user-policies"
  users      = [aws_iam_user.kops_iam_user.name]
  count      = length(var.policies)
  policy_arn = var.policies[count.index]
  depends_on = [aws_iam_user.kops_iam_user]
}

resource "null_resource" "create_cluster" {

  depends_on = [aws_iam_user.kops_iam_user, aws_s3_bucket.kops_state]

  provisioner "local-exec" {
    command = <<EOT
     aws configure set aws_access_key_id ${aws_iam_access_key.kops_iam_user_access_key.id} --profile ${aws_iam_user.kops_iam_user.name} && \
     aws configure set aws_secret_access_key ${aws_iam_access_key.kops_iam_user_access_key.secret} --profile ${aws_iam_user.kops_iam_user.name} && \
     aws configure set region ${var.region} --profile ${aws_iam_user.kops_iam_user.name} && \
     aws configure set output "json" --profile ${aws_iam_user.kops_iam_user.name}
    EOT    
  }

  # provisioner "local-exec" {

  #   environment = {
  #     AWS_PROFILE       = aws_iam_user.kops_iam_user.name
  #     AWS_REGION        = var.region
  #     KOPS_STATE_STORE  = "s3://${aws_s3_bucket.kops_state.bucket}"
  #   }

  #   command = <<EOT
  #     sleep 50
  #     kops create cluster --name="${var.cluster_name}.${var.domain}" --node-count=3 --zones=${var.zones} --node-size=${var.node_size} --master-size=${var.master_size} --master-zones=${var.zones} --networking=calico --topology=private --kubernetes-version=1.22.15 --master-image=${var.instance_image} --node-image=${var.instance_image} --ssh-public-key=${var.ssh_public_key} --bastion=true --yes
  #   EOT
  # }
}
