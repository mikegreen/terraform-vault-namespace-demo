# vars.tf
# 

# variable "vault_addr" {
#   type    = string
#   default = "http://ec2-123-123-123-115.us-east-2.compute.amazonaws.com:8200/"
# }

# variable "vault_token" {
#   type    = string
#   default = "your_token_here"
# }

# defined here but should be passed via CLI
variable "namespace" {
  type = string
  #  default = "example_namespace"
}
