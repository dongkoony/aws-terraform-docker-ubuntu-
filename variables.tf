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

# variable "cidr_blocks" {
#   description = "CIDR blocks for the security group"
#   default     = "172.31.64.0/20"
# }

# variable "your_machine_ip" {
#   description = "The IP address of your machine"
#   default     = "10.32.100.45"
# }


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
  default = "ap-northeast-2a" # 가용 영역
}

variable "ami_id" {
  type    = string
  default = "ami-0c9c942bd7bf113a2" # ubuntu 22.04
}

variable "docker_source_path" {
  description = "Local Docker Binary 경로"
  default     = "/Users/donghyeonshin/Desktop/docker-23.0.0.tgz"
}

variable "docker_binary_path" {
  description = "/home/ubuntu -> /usr/local/bin"
  default     = "/usr/local/bin/docker-23.0.0.tgz"
}

variable "docker_dest_path" {
  description = "Local -> /home/ubuntu mv"
  default     = "/home/ubuntu/docker-23.0.0.tgz"
}

variable "docker_service_unit_file_add" {
  description = "docker 유닛 파일 생성"
  default     = "/etc/systemd/system/docker.service"
}

variable "your_machine_ip" {
  description = "내부 통신 IP"
  default     = "59.18.140.252"
}

variable "cidr_blocks" {
  description = "The CIDR blocks for internal communication"
  default     = "172.31.64.0/20"
}