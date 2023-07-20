variable "region" {
  type    = string
  default = "ap-northeast-2" # 서울 리전
  
}

variable "instance_type" {
  type    = string
  default = "t3.medium"
}


variable "vpc_id" {
  type    = string
  default = "vpc-0d34cb0a905197a86"
}

variable "key_name" { 
  type    = string
  default = "Kubectl" # aws에서 발급 받은 pem key name
}

variable "public_key_path" {
  type    = string
  default = "/Users/donghyeonshin/Desktop/pem_key/Kubectl.pem" # aws에서 발급 받은 pem key 저장 디렉토리
}

variable "subnet_cidr_block" {
  type    = string
  default = "172.31.64.0/20"
}

variable "availability_zone" {
  type    = string
  default = "ap-northeast-2a"
}

variable "ami_id" {
  type    = string
  default = "ami-0c9c942bd7bf113a2" # ubuntu 22.04
}

