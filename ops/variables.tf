

variable "image_id" {
  type = "string"
  default = "ami-" #with docker
}

variable "instance_type" {
  type = "string"
  default = "t2.medium"
}

variable "vpc_id" {
  type = "string"
}

variable "public_subnets" {
  type = "list"
}

variable "private_subnets" {
  type = "list"
}

variable "nginx-host" {
  type = "string"
}






