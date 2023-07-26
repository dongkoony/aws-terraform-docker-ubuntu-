# AWS Provider 설정
provider "aws" {
  region = var.region
}

# 보안 그룹 생성
resource "aws_security_group" "kubernetes_security_group" {
  name_prefix = "kubernetes-security-group"
  vpc_id      = var.vpc_id

  # SSH Port 내부 통신을 위한 CIDR BLOCK IP 수정
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.31.64.0/20"]
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

# 원격 호스트에 도커 바이너리 복사
resource "null_resource" "copy_docker_binary" {
  provisioner "local-exec" {
    command = "scp ${data.http.docker_binary.body} ${var.remote_username}@${var.remote_host}:/path/to/destination/docker"
  }
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
    Name = "master-ec2"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.public_key_path) # aws에서 발급 받은 pem key 저장 디렉토리
    host        = self.public_ip
  }

  provisioner "local-exec" {
    command     = "sudo ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime"
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
    Name = "node1-ec2"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.public_key_path) # aws에서 발급 받은 pem key 저장 디렉토리
    host        = self.public_ip
  }

  provisioner "local-exec" {
    command     = "sudo ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime"
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
    Name = "node2-ec2"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.public_key_path) # aws에서 발급 받은 pem key 저장 디렉토리
    host        = self.public_ip
  }

  provisioner "local-exec" {
    command     = "sudo ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime"
  }
}

# Docker 바이너리 복사 및 설치 수행을 원격 호스트에 연결
resource "null_resource" "docker_installation" {
  depends_on = [
    null_resource.copy_docker_binary,
    aws_instance.ec2_instance_master,
    aws_instance.ec2_instance_node1,
    aws_instance.ec2_instance_node2
  ]

  provisioner "remote-exec" {
    inline = [
      # 복사한 파일 압축 해제
      "sudo tar xzvf /path/to/destination/docker -C /docker/",
      # 압축 해제한 파일을 /usr/bin으로 이동
      "sudo cp /docker/* /usr/bin/",
      # Dockerd 실행
      "sudo dockerd &"
    ]
  }
}
