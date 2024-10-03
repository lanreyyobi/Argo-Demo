variable "create_role" {
  type    = bool
  default = true
}

variable "attach_efs_csi_policy" {
  type    = bool
  default = true
}

variable "addons" {
  type = list(object({
    name    = string
    version = string
  }))
  default = [
    {
      name    = "aws-efs-csi-driver"
      version = "v2.0.7-eksbuild.1"
    },
    # {
    #  name    = "vpc-cni"
    #  version = "v1.15.1-eksbuild.1"
    # },
    {
      name    = "aws-ebs-csi-driver"
      version = "v1.35.0-eksbuild.1"
    }
  ]
}

variable "subnet_tags" {
  type    = string
  default = "private"
}