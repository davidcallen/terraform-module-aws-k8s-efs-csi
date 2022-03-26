locals {
  storage_class_name = var.dynamic_provisioning_enabled ? "efs-csi-sc-dynamic" : "efs-csi-sc"
}
# ---------------------------------------------------------------------------------------------------------------------
# EFS CSI Driver
# Note : You can't use dynamic persistent volume provisioning with Fargate nodes, but you can use static provisioning.
# ---------------------------------------------------------------------------------------------------------------------
resource "helm_release" "efs-csi-driver-static" {
  count      = var.dynamic_provisioning_enabled ? 0 : 1
  name       = "aws-efs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"
  chart      = "aws-efs-csi-driver"
  set {
    name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.k8s-efs-csi-driver.arn
    type  = "string"
  }
  # I found that using the Helm Chart for efs-csi-driver would fail with error on one of the efs-csi-controller pods with :
  #  "didn't have free ports for the requested pod ports"
  # workaround is to set the replicaCount=1 (instead of default of 2).
  # Presumably caused by my having a single k8s Node - perhaps the efs-csi-controller should use daemonset ?
  set {
    name  = "replicaCount"
    value = "1"
  }
  set {
    name  = "storageClasses[0].name"
    value = local.storage_class_name
  }
  set {
    name  = "storageClasses[0].mountOptions[0]"
    value = "tls"
  }
}
resource "helm_release" "efs-csi-driver-dynamic" {
  count      = var.dynamic_provisioning_enabled ? 1 : 0
  name       = "aws-efs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"
  chart      = "aws-efs-csi-driver"
  set {
    name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.k8s-efs-csi-driver.arn
    type  = "string"
  }
  # I found that using the Helm Chart for efs-csi-driver would fail with error on one of the efs-csi-controller pods with :
  #  "didn't have free ports for the requested pod ports"
  # workaround is to set the replicaCount=1 (instead of default of 2).
  # Presumably caused by my having a single k8s Node - perhaps the efs-csi-controller should use daemonset ?
  set {
    name  = "replicaCount"
    value = "1"
  }
  set {
    name  = "storageClasses[0].name"
    value = local.storage_class_name
  }
  set {
    name  = "storageClasses[0].mountOptions[0]"
    value = "tls"
  }
}

# Service account based from here :
#   https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html
resource "kubernetes_service_account" "efs-csi-driver" {
  metadata {
    name      = "efs-csi-controller-sa"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name" = "aws-efs-csi-driver"
    }
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.k8s-efs-csi-driver.arn
    }
  }
}
