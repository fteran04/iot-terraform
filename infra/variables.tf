variable "vpc_id" {
  default = "vpc-02b73f22d01a213cf"
}

variable "ami_id" {
  default = "ami-02dfbd4ff395f2a1b"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "key_name" {
  default = "mi-clave"
}

variable "subnets" {
  default = [
    "subnet-03e326867a44355f7",
    "subnet-0bebc93e2815a0f6d",
    "subnet-0ea41e3bb2080dd8b"
  ]
}