variable "create_role" {
  type    = bool
  default = true
}

variable "attach_efs_csi_policy" {
  type    = bool
  default = true
}

variable "subnet_tags" {
  type = string
  default = "private"
}