# terraform-module-aws-k8s-efs-csi

Terraform module to deploy AWS EFS CSI Driver on EKS

For details see [source code](https://github.com/kubernetes-sigs/aws-efs-csi-driver)
and [docs](https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html).

Uses their Helm chart to deploy it.

Supports Static and Dynamic provisioning.

Note for Dynamic provisioning this module will create the EFS File System for you.

TODO 
------
I found that using the Helm Chart for efs-csi-driver would fail with error on one of the efs-csi-controller pods with : "didn't have free ports for the requested pod ports".

Currenty workaround/hack is to set the replicaCount=1 (instead of default of 2).

Presumably caused by my having a single k8s Node - perhaps the efs-csi-controller should use daemonset ?