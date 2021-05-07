variable "new-namespace" {
	type = string
}

variable "admin-policy-content" {
	type = string
}

variable "secrets-manager-policy-content" {
	type = string
}

variable "path-prefix" {
	type = string
	default = "bootstrapped"
}

variable "secrets_to_mount" {
	type = list
	default = ["kv","kv-v2","pki","transit"]
}

variable "auths_to_mount" {
	type = list
	default = ["userpass","aws"]
}