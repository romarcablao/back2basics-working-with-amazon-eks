variable "name" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "node_iam_role_name" {
  type = string
}

variable "labels" {
  type    = map(any)
  default = {}
}

variable "taints" {
  type    = list(map(any))
  default = []
}

variable "consolidation_policy" {
  type    = string
  default = "WhenEmpty"
}

variable "consolidate_after" {
  type    = string
  default = ""
}

variable "instance_category" {
  type    = list(string)
  default = ["t", "m"]
}

variable "instance_cpu" {
  type    = list(string)
  default = ["2", "4", "8", "16"]
}

variable "instance_hypervisor" {
  type    = list(string)
  default = ["nitro"]
}

variable "arch" {
  type    = list(string)
  default = ["amd64"]
}

variable "capacity_type" {
  type    = list(string)
  default = ["spot", "on-demand"]
}