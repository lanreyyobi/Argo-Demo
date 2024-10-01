
variable "datadog_api_key" {
  type    = string
  default = ""
}

variable "datadog_app_key" {
  type    = string
  default = ""
}

variable "datadog_api_url" {
  type    = string
  default = "https://api.us5.datadoghq.com/"
}

variable "application_name" {
  type        = string
  description = "Application Name"
  default     = "datadog"
}

variable "datadog_site" {
  type        = string
  description = "Datadog Site Parameter"
  default     = "us5.datadoghq.com"
}




