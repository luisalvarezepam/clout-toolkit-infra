variable "location" {
  description = "Ubicación para todos los recursos"
  type        = string
  default     = "Central US"
}

variable "tenant_id" {
  type = string
}

variable "admin_object_id" {
  description = "Object ID del administrador"
  type        = string
  sensitive   = true
}

variable "app_registration_object_id" {
  description = "Object ID del App Registration"
  type        = string
  sensitive   = true
}

variable "use_private_image" {
  type        = bool
  description = "Define si se debe usar imagen privada del ACR o una pública temporal"
  default     = false
}

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
  sensitive   = true
}
