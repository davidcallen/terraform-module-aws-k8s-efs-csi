# ---------------------------------------------------------------------------------------------------------------------
# Kubernetes : Security group to control access to EFS from the cluster
# ---------------------------------------------------------------------------------------------------------------------

# Allow both ingress and egress for port 2049 (NFS) for our EC2 instances
# Restrict the traffic to between the VPC and the Cluster.
resource "aws_security_group" "k8s-cluster-efs" {
  name        = "${var.name}-cluster-efs"
  description = "Allows NFS traffic from the kubernetes cluster."
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = var.vpc_private_subnet_cidrs
  }
  egress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = var.vpc_private_subnet_cidrs
  }
  tags = merge(var.global_default_tags, var.environment.default_tags, {
    Name        = "${var.name}-cluster-efs"
    Application = "kubernetes"
  })
}

