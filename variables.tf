variable "name" {
  type        = string
  description = "API Gateway name"
}

variable "protocol_type" {
  type        = string
  description = "Protocol type"

  validation {
    condition     = contains(["HTTP", "WEBSOCKET"], var.protocol_type)
    error_message = "protocol_type must be one of HTTP or WEBSOCKET."
  }
}

variable "description" {
  type        = string
  description = "API description"
  default     = null
}

variable "api_version" {
  type        = string
  description = "API version"
  default     = null
}

variable "disable_execute_api_endpoint" {
  type        = bool
  description = "Disable default execute API endpoint"
  default     = false
}

variable "cors_configuration" {
  type        = any
  description = "CORS configuration"
  default     = null
}

variable "routes" {
  type        = any
  description = "Routes configuration"
  default     = []
}

variable "integrations" {
  type        = any
  description = "Integrations configuration"
  default     = []
}

variable "authorizers" {
  type        = any
  description = "Authorizers configuration"
  default     = []
}

variable "stages" {
  type        = any
  description = "Stages configuration"
  default     = []
}

variable "domain_name" {
  type        = string
  description = "Custom domain name"
  default     = null
}

variable "domain_name_certificate_arn" {
  type        = string
  description = "Domain name certificate ARN"
  default     = null
}

variable "vpc_link_id" {
  type        = string
  description = "VPC link ID"
  default     = null
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs"
  default     = []
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security group IDs"
  default     = []
}

variable "access_log_settings" {
  type        = any
  description = "Access log settings"
  default     = null
}

variable "throttling_burst_limit" {
  type        = number
  description = "Throttling burst limit"
  default     = 5000
}

variable "throttling_rate_limit" {
  type        = number
  description = "Throttling rate limit"
  default     = 10000
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply"
  default     = {}
}
