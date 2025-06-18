variable "name_suffix" {
  description = "Suffix to append to resource names"
  type        = string
}

variable "location" {
  description = "Azure region for the workspace"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
