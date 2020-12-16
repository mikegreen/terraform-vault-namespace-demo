# variables.tf

variable "vault_addr" {
  type = string
}

variable "vault_token" {
  type = string
  # default = "your_token_here"
}

variable "secrets_to_mount" {
	type = list
	# default = ["kv","kv-v2","pki","transit"]

}

variable "auths_to_mount" {
	type = list
	# default = ["userpass","aws"]
}