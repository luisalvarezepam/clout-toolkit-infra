variable "name" {
  description = "Nombre del diagnostic setting"
  type        = string
}

variable "target_resource_id" {
  description = "ID del recurso al que se aplicará el diagnóstico"
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "ID del Log Analytics Workspace"
  type        = string
}
