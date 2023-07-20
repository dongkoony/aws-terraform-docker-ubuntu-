# AWS Provider 설정
provider "aws" {
  region = var.region
}

# 보안 그룹 생성
resource "aws_security_group" "kubernetes_security_group" {
  name_prefix = "kubernetes-security-group"
  vpc_id      = var.vpc_id

  # SSH, 도커 포트, 쿠버네티스 포트, 젠킨스 포트 허용
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 2375
    to_port     = 2375
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 서브넷 생성
resource "aws_subnet" "kubernetes_subnet" {
  vpc_id            = var.vpc_id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.availability_zone
}

# EC2 마스터 인스턴스 생성
resource "aws_instance" "ec2_instance_master" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name # aws에서 발급 받은 pem key name
  subnet_id     = aws_subnet.kubernetes_subnet.id
  vpc_security_group_ids = [aws_security_group.kubernetes_security_group.id]
  associate_public_ip_address = true

  tags = {
    Name = "k8s-master"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.public_key_path) # aws에서 발급 받은 pem key 저장 디렉토리
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      # Local time
      # "sudo -i",
      "sudo rm -f /etc/localtime",
      "sudo ln -s /usr/share/zoneinfo/Asia/Seoul /etc/localtime",
      # "exit",
      
      # docker install
      
      "sudo apt-get update",
      "sudo apt-get install -y docker.io",
      "sudo systemctl enable --now docker",

      # jenkins container pull
      "sudo docker pull jenkins/jenkins:latest",

      # jenkins container Run
      "sudo docker run -d -p 8080:8080 -p 50000:50000 --name jenkins_container jenkins/jenkins:latest",

      # jenkins install

      # "curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null",
      # "echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null",
      # "sudo apt-get update",
      # "sudo apt-get install -y fontconfig openjdk-11-jre",
      # "sudo apt-get install -y jenkins"
    ]
  }
}

# EC2 노드1 인스턴스 생성
resource "aws_instance" "ec2_instance_node1" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name # aws에서 발급 받은 pem key name
  subnet_id     = aws_subnet.kubernetes_subnet.id
  vpc_security_group_ids = [aws_security_group.kubernetes_security_group.id]
  associate_public_ip_address = true

  tags = {
    Name = "k8s-node1"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.public_key_path) # aws에서 발급 받은 pem key 저장 디렉토리
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      # Local time
      # "sudo -i",
      "sudo rm -f /etc/localtime",
      "sudo ln -s /usr/share/zoneinfo/Asia/Seoul /etc/localtime",
      # "exit",

      # docker install
      "sudo apt-get update",
      "sudo apt-get install -y docker.io",
      "sudo systemctl enable --now docker"
    ]
  }
}

# EC2 노드2 인스턴스 생성
resource "aws_instance" "ec2_instance_node2" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name # aws에서 발급 받은 pem key name
  subnet_id     = aws_subnet.kubernetes_subnet.id
  vpc_security_group_ids = [aws_security_group.kubernetes_security_group.id]
  associate_public_ip_address = true

  tags = {
    Name = "k8s-node2"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.public_key_path) # aws에서 발급 받은 pem key 저장 디렉토리
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [

      # Local time
      # "sudo -i",
      "sudo rm -f /etc/localtime",
      "sudo ln -s /usr/share/zoneinfo/Asia/Seoul /etc/localtime",
      # "exit",

      # docker install
      "sudo apt-get update",
      "sudo apt-get install -y docker.io",
      "sudo systemctl enable --now docker"
    ]
  }
}

  # 테스트 코드 

# # IAM 사용자 생성
# resource "aws_iam_user" "jenkins_docker_user" {
#   name = "jenkins-docker-user" # 사용자 이름 설정
# }

# # IAM 정책 생성
# resource "aws_iam_policy" "jenkins_docker_policy" {
#   name        = "jenkins-docker-policy"
#   description = "Policy for Jenkins and Docker EC2 access"

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect   = "Allow"
#         Action   = "ec2:DescribeInstances"
#         Resource = [
#           aws_instance.ec2_instance_master.arn,
#           aws_instance.ec2_instance_node1.arn,
#           aws_instance.ec2_instance_node2.arn,
#         ]
#       },
#       {
#         Effect   = "Allow"
#         Action   = "ec2:StartInstances"
#         Resource = [
#           aws_instance.ec2_instance_master.arn,
#           aws_instance.ec2_instance_node1.arn,
#           aws_instance.ec2_instance_node2.arn,
#         ]
#       }
#           # instance 중지 정책
#       # {
#       #   Effect   = "Allow"
#       #   Action   = "ec2:StopInstances"
#       #   Resource = [
#       #     aws_instance.ec2_instance_master.arn,
#       #     aws_instance.ec2_instance_node1.arn,
#       #     aws_instance.ec2_instance_node2.arn,
#       #   ]
#       # },
#           # instance 재부팅 정책
#       # {
#       #   Effect   = "Allow"
#       #   Action   = "ec2:RebootInstances"
#       #   Resource = [
#       #     aws_instance.ec2_instance_master.arn,
#       #     aws_instance.ec2_instance_node1.arn,
#       #     aws_instance.ec2_instance_node2.arn,
#       #   ]
#       # }
#     ]
#   })
# }

# # IAM 정책과 사용자 연결
# resource "aws_iam_user_policy_attachment" "jenkins_docker_policy_attachment" {
#   policy_arn = aws_iam_policy.jenkins_docker_policy.arn
#   user       = aws_iam_user.jenkins_docker_user.name
# }