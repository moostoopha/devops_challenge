variable "tags" {
  type = "map" 
  default = {
    c-domain= "monitoring"
  }
}

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

variable "security_groups" {
  type = "list"
}

variable "r53_name" {
  type = "string"
}

variable "r53_zone_id" {
  type = "string"
}

variable "nginx host" {
  type = "string"
}

variable "iam_instance_profile" {
  type = "string"
  default = "nginx-v2"
}

variable "certificate_arn" {
  type = "string"
  default = ""
}

variable "security" {
  type = "string"
  default = ""
}


# variable "authorization_endpoint" {
#   type = "string"
# }

# variable "issuer" {
#   type = "string"
# }

# variable "token_endpoint" {
#   type = "string"
# }

# variable "user_info_endpoint" {
#   type = "string"
# }