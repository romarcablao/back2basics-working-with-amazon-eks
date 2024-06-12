variable "environment" {
  description = "Environment"
  type        = string
  default     = "demo"
}

variable "default_tags" {
  description = "Default tags to use"
  type        = map(string)
  default = {
    CostCenter = "Back2Basics"
    CreatedBy  = "OpenTofu"
  }
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "my-cluster"
}

variable "region" {
  description = "AWS Region to use"
  type        = string
  default     = "ap-southeast-1"
}

variable "cluster_version" {
  description = "Version of the EKS cluster"
  type        = string
  default     = "1.30"
}

variable "vpc_cidr" {
  description = "CIDR block used on VPC created for EKS"
  type        = string
  default     = "10.42.0.0/16"
}

variable "enable_grafana" {
  description = "Enabling/disabling Grafana deployment"
  type        = bool
  default     = false
}

variable "enable_prometheus" {
  description = "Enabling/disabling Prometheus deployment"
  type        = bool
  default     = false
}