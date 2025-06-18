variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}


variable "name_suffix" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "subnet_ids" {
  type = object({
    public  = string
    private = string
    db      = string
  })
}

variable "subnet_prefixes" {
  description = "CIDR blocks por subred"
  type = object({
    public  = string
    private = string
    db      = string
  })
}
