provider "vault" {
  alias     = "new"
  namespace = var.new-namespace
}

provider "vault" {
  alias = "vault-root"
}

resource "vault_namespace" "new-namespace" {
  provider = vault.vault-root
  path     = var.new-namespace
}

resource "vault_aws_secret_backend" "aws" {
  depends_on                = [vault_namespace.new-namespace]
  provider                  = vault.new
  access_key                = var.aws-key
  secret_key                = var.aws-secret
  default_lease_ttl_seconds = 3600
  max_lease_ttl_seconds     = 86400
  path                      = "aws"
  region                    = "us-east-2"
}

resource "vault_aws_secret_backend_role" "ec2-role" {
  provider        = vault.new
  backend         = vault_aws_secret_backend.aws.path
  name            = "ec2-deploy"
  credential_type = "iam_user"

  policy_document = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ec2:*",
      "Resource": "*"
    }
  ]
}
EOT
}

