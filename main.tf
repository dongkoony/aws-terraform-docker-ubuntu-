# AWS Provider 설정
provider "aws" {
  region = "ap-northeast-2" # 사용하는 리전으로 변경
}

# 보안 그룹 생성
resource "aws_security_group" "kubernetes_security_group" {
  name_prefix = "kubernetes-security-group"
  vpc_id      = "vpc-0d34cb0a905197a86" # 사용하는 VPC ID로 대체

  # SSH 트래픽 허용
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # SSH를 모든 IP 주소에서 허용하려면 0.0.0.0/0
  }

  # 도커 포트 허용 (도커 데몬이 2375 포트를 사용)
  ingress {
    from_port   = 2375
    to_port     = 2375
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # 모든 IP 주소에서 도커 포트 허용
  }

  # 쿠버네티스 마스터, 노드간 통신 허용 (포트 번호는 구성에 따라 달라질 수 있음)
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # 모든 IP 주소에서 쿠버네티스 마스터, 노드 통신 허용
  }

  # 젠킨스 포트 허용 (젠킨스 웹 인터페이스가 8080 포트를 사용)
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # 모든 IP 주소에서 젠킨스 포트 허용
  }

  # 모든 아웃바운드 트래픽 허용
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 서브넷 생성
resource "aws_subnet" "kubernetes_subnet" {
  vpc_id            = "vpc-0d34cb0a905197a86" # 사용하는 VPC ID로 대체
  cidr_block        = "172.31.64.0/20" # 다른 CIDR 블록으로 변경
  availability_zone = "ap-northeast-2a"
}

# EC2 마스터 인스턴스 생성
resource "aws_instance" "ec2_instance_master" {
  ami           = "ami-0c9c942bd7bf113a2" # ubuntu 22.04 ami
  instance_type = "t3.medium"
  key_name      = "Kubectl" # 사용하는 키 페어 이름으로 대체
  subnet_id     = aws_subnet.kubernetes_subnet.id
  vpc_security_group_ids = [aws_security_group.kubernetes_security_group.id]
  associate_public_ip_address = true # 퍼블릭 IP를 할당

  tags = {
    Name = "k8s-master"
  }

  # ec2 인스턴스 생성 후 ssh 자동 접속
  connection {
    type        = "ssh"
    user        = "ubuntu" # 원격 인스턴스의 사용자 이름 (예: Ubuntu AMI를 사용하는 경우)
    private_key = file("/Users/donghyeonshin/Desktop/pem_key/Kubectl.pem") # AWS에서 발급한 PEM 키 파일의 경로
    host        = self.public_ip # 인스턴스가 생성된 후에 퍼블릭 IP 주소로 자동으로 채워집니다.
  }

  # docker와 jenkins install
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y docker.io",
      "sudo systemctl enable --now docker"

      # jenkins install error
      
      # "sudo apt-get install -y gnupg2", # gnupg2 설치
      # "curl -fsSL https://pkg.jenkins.io/debian/jenkins.io.key | sudo gpg --dearmor --yes -o /usr/share/keyrings/jenkins-archive-keyring.gpg",
      # "echo 'deb [signed-by=/usr/share/keyrings/jenkins-archive-keyring.gpg] https://pkg.jenkins.io/debian-stable binary/' | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null",
      # "sudo apt-get update",
      # "sudo apt-get install -y fontconfig openjdk-11-jre",
      # "sudo apt-get install -y jenkins"
    ]
  }
}

# EC2 노드1 인스턴스 생성
resource "aws_instance" "ec2_instance_node1" {
  ami           = "ami-0c9c942bd7bf113a2" # ubuntu 22.04 ami
  instance_type = "t3.medium"
  key_name      = "Kubectl" # 사용하는 키 페어 이름으로 대체
  subnet_id     = aws_subnet.kubernetes_subnet.id
  vpc_security_group_ids = [aws_security_group.kubernetes_security_group.id]
  associate_public_ip_address = true # 퍼블릭 IP를 할당

  tags = {
    Name = "k8s-node1"
  }

  # ec2 인스턴스 생성 후 ssh 자동 접속
  connection {
    type        = "ssh"
    user        = "ubuntu" # 원격 인스턴스의 사용자 이름 (예: Ubuntu AMI를 사용하는 경우)
    private_key = file("/Users/donghyeonshin/Desktop/pem_key/Kubectl.pem") # AWS에서 발급한 PEM 키 파일의 경로
    host        = self.public_ip # 인스턴스가 생성된 후에 퍼블릭 IP 주소로 자동으로 채워집니다.
  }

  # docker auto install 
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y docker.io",
      "sudo systemctl enable --now docker"
    ]
  }
}


# EC2 노드2 인스턴스 생성
resource "aws_instance" "ec2_instance_node2" {
  ami           = "ami-0c9c942bd7bf113a2" # ubuntu 22.04 ami
  instance_type = "t3.medium"
  key_name      = "Kubectl" # 사용하는 키 페어 이름으로 대체
  subnet_id     = aws_subnet.kubernetes_subnet.id
  vpc_security_group_ids = [aws_security_group.kubernetes_security_group.id]
  associate_public_ip_address = true # 퍼블릭 IP를 할당

  tags = {
    Name = "k8s-node2"
  }

  # ec2 인스턴스 생성 후 ssh 자동 접속
  connection {
    type        = "ssh"
    user        = "ubuntu" # 원격 인스턴스의 사용자 이름 (예: Ubuntu AMI를 사용하는 경우)
    private_key = file("/Users/donghyeonshin/Desktop/pem_key/Kubectl.pem") # AWS에서 발급한 PEM 키 파일의 경로
    host        = self.public_ip # 인스턴스가 생성된 후에 퍼블릭 IP 주소로 자동으로 채워집니다.
  }

  # docker auto install 
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y docker.io",
      "sudo systemctl enable --now docker"
    ]
  }
}