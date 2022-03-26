# ---------------------------------------------------------------------------------------------------------------------
# Kubernetes : IAM for EFS CSI Driver
# ---------------------------------------------------------------------------------------------------------------------
# Role contents based from here :
#   https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html
resource "aws_iam_role" "k8s-efs-csi-driver" {
  name               = "${var.name}-k8s-cluster-efs-csi-driver"
  description        = "Allow fargate cluster to allocate resources for running pods"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::${var.environment.account_id}:oidc-provider/${trimprefix(var.cluster_identity_oidc_issuer, "https://")}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${trimprefix(var.cluster_identity_oidc_issuer, "https://")}:sub": "system:serviceaccount:kube-system:efs-csi-controller-sa"
        }
      }
    }
  ]
}
EOF
}
# Policy contents based from here :
#   https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html
resource "aws_iam_policy" "k8s-efs-csi-driver" {
  name        = "${var.name}-cluster-efs-csi-driver"
  description = "IAM policy that allows the CSI driver's service account to make calls to AWS APIs on your behalf."
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "elasticfilesystem:DescribeAccessPoints",
        "elasticfilesystem:DescribeFileSystems",
        "elasticfilesystem:DescribeMountTargets",
        "ec2:DescribeAvailabilityZones"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "elasticfilesystem:CreateAccessPoint"
      ],
      "Resource": "*",
      "Condition": {
        "StringLike": {
          "aws:RequestTag/efs.csi.aws.com/cluster": "true"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": "elasticfilesystem:DeleteAccessPoint",
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "aws:ResourceTag/efs.csi.aws.com/cluster": "true"
        }
      }
    }
  ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "k8s-efs-csi-driver" {
  policy_arn = aws_iam_policy.k8s-efs-csi-driver.arn
  role       = aws_iam_role.k8s-efs-csi-driver.name
}