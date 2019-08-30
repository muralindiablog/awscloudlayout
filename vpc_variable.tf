variable "awspregion" {
    default = "us-east-1"
}
variable "devvpc_cidr" {
  default = "10.11.0.0/20"
}
variable "az_count" {
  default ="3"
}
variable "pubaz_count" {
  default ="2"
}
variable "natsgport1" {
  default ="80"
}
variable "natsgport2" {
  default ="443"
}
variable "natsgport3" {
  default = "22"
}

#variable "devpri_subnet_id" {}





