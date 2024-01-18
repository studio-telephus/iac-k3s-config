variable "env" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "enable_automatic_node_reboot" {
  description = "Enable automatic reboot of K8s nodes for OS upgrades"
  default     = true
  # Set this to 'false' if you don't want unattended, uncontrolled VM reboots (via kured) and/or your workload cannot handle pod rescheduling
}
