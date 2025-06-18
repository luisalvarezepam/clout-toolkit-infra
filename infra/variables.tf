variable "location" {
  description = "Ubicación para todos los recursos"
  type        = string
  default     = "Central US"
}

variable "tenant_id" {
  type = string
}

variable "admin_object_id" {
  type        = string
  description = "Object ID de tu usuario admin (para acceso completo al Key Vault)"
}

variable "app_registration_object_id" {
  type        = string
  description = "Object ID del App Registration que usa Terraform"
}

variable "use_private_image" {
  type        = bool
  description = "Define si se debe usar imagen privada del ACR o una pública temporal"
  default     = false
}
