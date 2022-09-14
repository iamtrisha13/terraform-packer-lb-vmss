variable "name" {
  default = "trisha"
}

variable "address_space" {
  type        = list(string)
  description = "The address space that is used by the virtual network."
  default     = ["10.0.0.0/16"]
}

variable "address_prefixes" {
  type        = list(string)
  description = "Address prefix of Subnet"
  default     = ["10.0.0.0/24"]
}

