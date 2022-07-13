# create secret
resource "aws_secretsmanager_secret" "kyler-super-secret-json" {
  name = "kyler-super-secret-json"
}
resource "aws_secretsmanager_secret" "kyler-secret-string" {
  name = "kyler-secret-string"
}

# No need to create policy here for same-account IAM principal and using Amazon encryption key

# create secret map
variable "secret-json" {
  default = {
    app_password   = "cindy1"
    smtp_password  = "cindy2"
    other_password = "cindy3"
  }
  type = map(string)
}

# Populate secret
resource "aws_secretsmanager_secret_version" "kyler-super-secret-json" {
  secret_id     = aws_secretsmanager_secret.kyler-super-secret-json.id
  secret_string = jsonencode(var.secret-json)
}
resource "aws_secretsmanager_secret_version" "kyler-secret-string" {
  secret_id     = aws_secretsmanager_secret.kyler-secret-string.id
  secret_string = "cindy77"
}
