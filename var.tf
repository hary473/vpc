#Defining CIDR Block for VPC 
variable "vpc_cidr" {
 default = " 192.168.0.0/16"
}

#Defining azs for subnets
variable "azs" {
  type= list(string)
  default=["ap-southeast-2a","ap-southeast-2b"]
}

#Defining CIDR block for public subnets
variable "pubsub" {
  type= list(string)
  default=["192.168.0.0/24","192.168.1.0/24"]
}

#Defining CIDR Block for pvt subnets
variable "pvtsub" {
 type= list(string)
 default=["192.168.2.0/24","192.168.3.024"]
}
