output "kops_s3_bucket_name" {
  value = aws_s3_bucket.kops_state.bucket
}
output "access_key" {
  value = aws_iam_access_key.kops_iam_user_access_key.id
}

output "secret" {
  sensitive = true
  value     = aws_iam_access_key.kops_iam_user_access_key.secret
}
