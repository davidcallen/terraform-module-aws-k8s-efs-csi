variable "aws_region" {
  type = string
}
variable "name" {
  description = "The Name of the deployed app (and its resources)"
  type        = string
  default     = ""
}
variable "namespace" {
  type = string
}
variable "environment" {
  description = "Environment information e.g. account IDs, public/private subnet cidrs"
  type = object({
    name                         = string # Environment Account IDs are used for giving permissions to those Accounts for resources such as AMIs
    account_id                   = string
    resource_name_prefix         = string # For some environments  (e.g. Core, Customer/production) want to protect against accidental deletion of resources
    resource_deletion_protection = bool
    default_tags                 = map(string)
  })
  default = {
    name                         = ""
    account_id                   = ""
    resource_name_prefix         = ""
    resource_deletion_protection = true
    default_tags                 = {}
  }
}
variable "org_domain_name" {
  description = "Domain name for organisation e.g. parkrunpointsleague.org"
  default     = ""
  type        = string
}
variable "org_short_name" {
  description = "Short name for organisation e.g. prpl"
  default     = ""
  type        = string
}
variable "cluster_name" {
  description = "The Kubernetes Cluster name"
  type        = string
  default     = ""
}
variable "cluster_identity_oidc_issuer" {
  type = string
}
variable "vpc_id" {
  description = "The VPC ID"
  type        = string
  default     = ""
}
variable "vpc_private_subnet_ids" {
  description = "The VPC private subnet IDs list"
  type        = list(string)
  default     = []
}
variable "vpc_private_subnet_cidrs" {
  description = "The VPC private subnet CIDRs list"
  type        = list(string)
  default     = []
}
variable "cluster_ingress_allowed_cidrs" {
  description = "The Cluster ingress allowed CIDRs list"
  type        = list(string)
  default     = []
}
variable "dynamic_provisioning_enabled" {
  type = bool
}
variable "global_default_tags" {
  description = "Global default tags"
  type        = map(string)
  default     = {}
}