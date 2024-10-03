data "aws_iam_policy_document" "ebs_csi" {
  count = var.create_role && var.attach_efs_csi_policy ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateSnapshot",
      "ec2:AttachVolume",
      "ec2:DetachVolume",
      "ec2:ModifyVolume",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeInstances",
      "ec2:DescribeSnapshots",
      "ec2:DescribeTags",
      "ec2:DescribeVolumes",
      "ec2:DescribeVolumesModifications"
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateTags"
    ]
    resources = [
      "arn:aws:ec2:*:*:volume/*",
      "arn:aws:ec2:*:*:snapshot/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "ec2:CreateAction"
      values   = ["CreateVolume", "CreateSnapshot"]
    }
  }
  statement {
    effect  = "Allow"
    actions = ["ec2:DeleteTags"]
    resources = [
      "arn:aws:ec2:*:*:volume/*",
      "arn:aws:ec2:*:*:snapshot/*"
    ]
  }
  statement {
    effect    = "Allow"
    actions   = ["ec2:CreateVolume"]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/ebs.csi.aws.com/cluster"
      values   = ["true"]
    }
  }
  statement {
    effect    = "Allow"
    actions   = ["ec2:CreateVolume"]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/CSIVolumeName"
      values   = ["*"]
    }
  }
  statement {
    effect    = "Allow"
    actions   = ["ec2:DeleteVolume"]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/ebs.csi.aws.com/cluster"
      values   = ["true"]
    }
  }
  statement {
    effect = "Allow"
    actions = [
      "ec2:DeleteVolume"
    ]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/CSIVolumeName"
      values   = ["*"]
    }
  }
  statement {
    effect = "Allow"
    actions = [
      "ec2:DeleteVolume"
    ]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/kubernetes.io/created-for/pvc/name"
      values   = ["*"]
    }
  }
  statement {
    effect = "Allow"
    actions = [
      "ec2:DeleteSnapshot"
    ]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/CSIVolumeSnapshotName"
      values   = ["*"]
    }
  }
  statement {
    effect = "Allow"
    actions = [
      "ec2:DeleteSnapshot"
    ]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/ebs.csi.aws.com/cluster"
      values   = ["true"]
    }
  }
}

