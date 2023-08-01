# AWS Provider 설정 
provider "aws" {
  region = var.region
}

# 보안 그룹 생성
resource "aws_security_group" "kubernetes_security_group" {
  name_prefix = "kubernetes-security-group"
  vpc_id      = var.vpc_id

  # SSH 포트
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.cidr_blocks, "${var.your_machine_ip}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_blocks, "${var.your_machine_ip}/32"]
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
    Name = "docker-master"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.public_key_path) # aws에서 발급 받은 pem key 저장 디렉토리
    host        = self.public_ip
  }


  provisioner "file" {
    source = var.docker_source_path
    destination = var.docker_dest_path
  }


  provisioner "remote-exec" {
    inline = [
      # Local time
      "sudo rm /etc/localtime",
      "sudo ln -s /usr/share/zoneinfo/Asia/Seoul /etc/localtime",
      
      # docker install
      # Copy Docker binary
      "sudo mv ${var.docker_dest_path} /usr/local/bin/",
      "sudo tar -xvzf ${var.docker_binary_path} --directory /usr/local/bin/ --strip-components=1",
      "sudo chmod +x /usr/local/bin/docker",

      # Remove Docker tarball
      "sudo rm ${var.docker_binary_path}",
      
      #  Docker 서비스 유닛 파일을 생성
      "echo '[Unit]' | sudo tee ${var.docker_service_unit_file_add}",
      "echo 'Description=Docker Daemon' | sudo tee -a ${var.docker_service_unit_file_add}",
      "echo 'After=network.target' | sudo tee -a ${var.docker_service_unit_file_add}",
      "echo '' | sudo tee -a ${var.docker_service_unit_file_add}",
      "echo '[Service]' | sudo tee -a ${var.docker_service_unit_file_add}",
      "echo 'ExecStart=/usr/local/bin/dockerd -H unix://' | sudo tee -a ${var.docker_service_unit_file_add}",
      "echo '' | sudo tee -a ${var.docker_service_unit_file_add}",
      "echo '[Install]' | sudo tee -a ${var.docker_service_unit_file_add}",
      "echo 'WantedBy=multi-user.target' | sudo tee -a ${var.docker_service_unit_file_add}",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable --now docker"
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
    Name = "docker-node1"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.public_key_path) # aws에서 발급 받은 pem key 저장 디렉토리
    host        = self.public_ip
  }

  provisioner "file" {
    source = var.docker_source_path
    destination = var.docker_dest_path
  }


  provisioner "remote-exec" {
    inline = [
      # Local time
      "sudo rm /etc/localtime",
      "sudo ln -s /usr/share/zoneinfo/Asia/Seoul /etc/localtime",
      
      # docker install
      # Copy Docker binary
      "sudo mv ${var.docker_dest_path} /usr/local/bin/",
      "sudo tar -xvzf ${var.docker_binary_path} --directory /usr/local/bin/ --strip-components=1",
      "sudo chmod +x /usr/local/bin/docker",

      # Remove Docker tarball
      "sudo rm ${var.docker_binary_path}",

      #  Docker 서비스 유닛 파일을 생성
      "echo '[Unit]' | sudo tee ${var.docker_service_unit_file_add}",
      "echo 'Description=Docker Daemon' | sudo tee -a ${var.docker_service_unit_file_add}",
      "echo 'After=network.target' | sudo tee -a ${var.docker_service_unit_file_add}",
      "echo '' | sudo tee -a ${var.docker_service_unit_file_add}",
      "echo '[Service]' | sudo tee -a ${var.docker_service_unit_file_add}",
      "echo 'ExecStart=/usr/local/bin/dockerd -H unix://' | sudo tee -a ${var.docker_service_unit_file_add}",
      "echo '' | sudo tee -a ${var.docker_service_unit_file_add}",
      "echo '[Install]' | sudo tee -a ${var.docker_service_unit_file_add}",
      "echo 'WantedBy=multi-user.target' | sudo tee -a ${var.docker_service_unit_file_add}",
      "sudo systemctl daemon-reload",
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
    Name = "docker-node2"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.public_key_path) # aws에서 발급 받은 pem key 저장 디렉토리
    host        = self.public_ip
  }

  provisioner "file" {
    source = var.docker_source_path
    destination = var.docker_dest_path
  }

  provisioner "remote-exec" {
    inline = [

      # Local time
      "sudo rm /etc/localtime",
      "sudo ln -s /usr/share/zoneinfo/Asia/Seoul /etc/localtime",
      
      # docker install
      # Copy Docker binary
      "sudo mv ${var.docker_dest_path} /usr/local/bin/",
      "sudo tar -xvzf ${var.docker_binary_path} --directory /usr/local/bin/ --strip-components=1",
      "sudo chmod +x /usr/local/bin/docker",

      # Remove Docker tarball
      "sudo rm ${var.docker_binary_path}",

      #  Docker 서비스 유닛 파일을 생성
      "echo '[Unit]' | sudo tee ${var.docker_service_unit_file_add}",
      "echo 'Description=Docker Daemon' | sudo tee -a ${var.docker_service_unit_file_add}",
      "echo 'After=network.target' | sudo tee -a ${var.docker_service_unit_file_add}",
      "echo '' | sudo tee -a ${var.docker_service_unit_file_add}",
      "echo '[Service]' | sudo tee -a ${var.docker_service_unit_file_add}",
      "echo 'ExecStart=/usr/local/bin/dockerd -H unix://' | sudo tee -a ${var.docker_service_unit_file_add}",
      "echo '' | sudo tee -a ${var.docker_service_unit_file_add}",
      "echo '[Install]' | sudo tee -a ${var.docker_service_unit_file_add}",
      "echo 'WantedBy=multi-user.target' | sudo tee -a ${var.docker_service_unit_file_add}",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable --now docker"
    ]
  }
}