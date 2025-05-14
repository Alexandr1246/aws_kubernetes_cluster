variable "aws_region" {
    description = "Defult AWS Region"
    type = string 
}

variable "role_name" {
    description = "AWS Kubernetes role name"
    type = string
}

variable "repo_owner" {
    description = "GitHub account name"
    type = string
}

variable "repo_name" {
    description = "GiHub Repositorie name"
    type = string
}

variable "repo_branch" {
    description = "GitHub branch name"
    type = string
}