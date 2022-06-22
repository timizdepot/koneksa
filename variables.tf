variable "region" {
    description = "AWS REGION"
    default = "us-east-1"
}

variable "vpc_cidr" {
   description = "VPC CIDR"
   default = "10.10.10.0/24" 
}

variable "subnet_cidr_a" {
    description = "Public Subnet 1 CIDR"
    default = "10.10.10.0/27"
}

variable "subnet_cidr_b" {
    description = "Private Subnet 1 CIDR"
    default = "10.10.10.32/27"
}

variable "subnet_cidr_c" {
    description = "Public Subnet 2 CIDR"
    default = "10.10.10.64/27"
}

variable "subnet_cidr_d" {
    description = "Database Subnet 1 CIDR"
    default = "10.10.10.96/27"
}


