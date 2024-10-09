
variable "private_key" {
  type    = string
  default = "./private_key"

}
variable "public_key" {
  type    = string
  default = "./public_key"

}
variable "user" {
  type    = string
  default = "perrynjenji@gmail.com"

}

variable "instances" {
  type = map(object({
    name          = string
    instance_type = string
  }))

}