variable "aws_region" {
    description = "Defult AWS Region"
    type = string
    default = "eu-north-1"
}

variable "role_name" {
    description = "AWS Kubernetes role name"
    type = string
    default = "kubernetes-cluster-admin"
}

variable "repo_owner" {
    description = "GitHub account name"
    type = string
    default = "Alexandr1246"
}

variable "repo_name" {
    description = "GiHub Repositorie name"
    type = string
    default = "aws_kubernetes_cluster"
}

variable "repo_branch" {
    description = "GitHub branch name"
    type = string
    default = "main"
}