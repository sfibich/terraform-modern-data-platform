variable "prefix" {
  type        = string
  description = "The prefix which should be used for all resources in this module"
  default     = "mdp"
}

variable "machine_number" {
  type        = string
  description = "unique instance number to be a suffix to the overall resource name and resource group"
}

variable "allowed_list_ips" {
  type        = string
  description = "The IP addresses that will be allowed to talk to the workstation controlled by the NSG; simple comma-delimited list"
  default     = null
}

variable "location" {
  type        = string
  description = "The Azure Region in which all resources in this module"
  default     = "eastus2"
}

variable "username" {
  type    = string
  default = "adminuser"
}

variable "password" {
  type    = string
  default = "P@ssw0rd1234!"
}

# Standard Tags

variable "tags" {
  default = {
    project = "terraform-modern-data-platform"
  }
  description = "The generic tags for this project that go on all resources"
  type        = map(string)

}

variable "env_tags" {
  default     = {}
  description = "Environment specific tags"
  type        = map(string)
}

variable "state_container_name" {
  default     = ""
  description = "Used by the boostrap shell script but provide here incase it is needed, in the output by default"
  type        = string
}

variable "state_key" {
  default     = ""
  description = "Used by the bootstrap shell script but provided here incase it is needed, in the output by default"
  type        = string
}

