# ---------------------------------------------------------------------------------------------------------------------
# Kubernetes EFS filesystem for use with dynamic provisioning
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_efs_file_system" "k8s-cluster-efs-dynamic" {
  count     = var.dynamic_provisioning_enabled ? 1 : 0
  encrypted = true
  lifecycle {
    prevent_destroy = false # cant use var.environment.resource_deletion_protection
  }
  tags = merge(var.global_default_tags, var.environment.default_tags, {
    Name = "${var.cluster_name}-efs"
  })
}
resource "aws_efs_mount_target" "k8s-cluster-efs" {
  count           = var.dynamic_provisioning_enabled ? length(var.vpc_private_subnet_ids) : 0
  file_system_id  = aws_efs_file_system.k8s-cluster-efs-dynamic[0].id
  subnet_id       = var.vpc_private_subnet_ids[count.index]
  security_groups = [aws_security_group.k8s-cluster-efs.id]
}

//resource "aws_efs_access_point" "k8s-jenkins-controller-efs" {
//  file_system_id    = aws_efs_file_system.k8s-jenkins-controller-efs.id
//  posix_user {
//    gid             = 1000
//    uid             = 1000
//  }
//  root_directory {
//    path            =  "/jenkins"
//    creation_info {
//      owner_gid = 1000
//      owner_uid = 1000
//      permissions = "777"
//    }
//  }
//}