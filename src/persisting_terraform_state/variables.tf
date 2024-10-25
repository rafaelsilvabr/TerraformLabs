variable "external_port" {
  type    = number
  default = 8080
  validation {
    condition     = var.external_port == 8080 || var.external_port == 80
    error_message = "The external can be only 8080 or 80"
  }
}