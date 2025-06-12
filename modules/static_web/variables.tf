variable "rg_name" {}
variable "location" {}
variable "repo_url" {}
variable "branch" {
  default = "main"
}
variable "custom_domain" {
  default = ""
}
variable "github_token" {
  description = "GitHub PAT with repo and workflow scope"
  sensitive   = true
}
