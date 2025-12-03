variable "region" { type = string }
variable "profile" { type = string }
variable "project" {
  type    = string
  default = "minecraft"
}
variable "instance_type" {
  type    = string
  default = "t3.medium"
}