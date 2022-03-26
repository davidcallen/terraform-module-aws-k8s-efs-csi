output "dynamic_efs_id" {
  value = var.dynamic_provisioning_enabled ? aws_efs_file_system.k8s-cluster-efs-dynamic[0].id : ""
}
output "security_group_efs_id" {
  value = aws_security_group.k8s-cluster-efs.id
}
output "storage_class_name" {
  value = local.storage_class_name
}