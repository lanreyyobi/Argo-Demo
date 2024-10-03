# EFS file system
resource "aws_efs_file_syste" "stw_node_efs" {
  creation_token = "efs-for-stw-node"

  tags = {
    Name = "eks-file-system"
  }
}

#efs mount targets
resource "aws_efs_mount_target" "stw_node_efs_mt_0" {
  file_system_id  = aws_efs_file_system.stw_node_efs.id
  subnet_id = data.aws_subnets.nodes.ids
  security_groups = [data.aws_security_groups.efs_sg.ids[0]
}

resource "aws_efs_mount_target" "stw_node_efs_mt_1" {
  file_system_id  = aws_efs_file_system.stw_node_efs.id
  subnet_id = data.aws_subnets.node.ids[1]
  security_groups = [data.aws_security_groups.efs_sg.ids[0]]
}

