# Secure-Cloud-Dock

## Secure-Cloud-Dock

**Secure**: 프로젝트는 보안 인프라를 구축하고 AWS 클라우드 환경에서 안전한 운영을 중요하게 생각합니다.

**Cloud**: 프로젝트는 AWS 클라우드 서비스를 활용하여 인프라를 관리하고, 클라우드 환경에서 실행됩니다.

**Dock**: 프로젝트는 Docker를 사용하여 컨테이너 기반 애플리케이션 관리와 배포를 수행합니다.

이 프로젝트는 AWS, Terraform, Docker를 활용하여 보안 인프라를 구축하고, EC2 인스턴스에 Docker를 설치하며, 서울 시간으로 자동 설정하는 작업을 수행하는 자동화 스크립트입니다.

## 프로젝트 개요

이 프로젝트는 AWS Cloud에서 Terraform을 사용하여 인프라를 구성하고, Docker binary를 설치하며, AWS EC2 인스턴스의 시간을 한국(서울) 시간으로 자동으로 변경하는 작업을 수행합니다. 
또한, 내부 통신망만 사용 가능한 보안 인프라를 구축하고, 로컬 환경에서 EC2로 Docker binary를 원격으로 전송하는 작업도 포함되어 있습니다.

## 현 프로젝트의  목표
```
1. Terraform apply시 AWS EC2인프라 구축
2. 구축 완료시 3개의 EC2 Localtime Seoul로 자동 변경
3. 3개 EC2에 Docker binary를  사용하여 설치
4. 내부 통신망만 사용가능한  AWS 인프라 구축
5. provisioner "file"을 사용하여 Local->EC2 원격으로 Docker binary 전송
```

## 주요 기능

1. **보안 인프라 구축**: AWS 및 Terraform을 사용하여 보안 강화된 인프라를 자동으로 구성합니다.

2. **EC2 인스턴스 설정**: EC2 인스턴스를 서울 시간으로 자동 설정하고 내부 통신망만을 사용할 수 있도록 환경을 조정합니다.

3. **Docker 자동 설치**: EC2 인스턴스에 Docker를 자동으로 설치하여 컨테이너화된 애플리케이션을 실행할 수 있도록 합니다.


## 설치 및 사용법

### 이 저장소를 클론합니다.
   ```bash
   git clone https://github.com/dongkoony/aws-terraform-docker-ubuntu-.git
   cd aws-terraform-docker-ubuntu-
   ```

### ifconfig
```
이 프로젝트에서 사용하는 인터넷 아이피 주소를 확인하려면 다음 URL을 사용하세요:
ifconfig.me
``` 

### Docker Binary Download
``` html
도커 바이너리를 다운로드하는 링크:
https://download.docker.com/linux/static/stable/x86_64/
```

### Terraform을 이용한 AWS EC2 서비스 내 도커 및 젠킨스 컨테이너 Pull IaC 현재 젠킨스 install 주석 처리
```
Terraform version : 1.5.0
aws-cli version : 2.12.3
python version : 3.11.4
Jenkins Container : -
Docker : -
```

### AWS CLI Install

**Linux Install**
``` bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```
**Windows Install**
``` bash
msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi

// 설치 후 버전 확인
aws --version
```

### AWS Configuration
``` bash
// AWS Access Key, Secret Key 구성
aws configure

// 설정 AWS IAM 액세스 key
AWS Access Key ID [None] :
AWS Secret Access Key [None] :
Default region name [None] : ap-northeast-2(서울)
Default output format [None] : json

// 등록 확인
aws configure list

// 여러 AWS 계정과 아이디로 운용할 경우
aws configure --profile [원하는 이름]
```

### Terraform install (Ubuntu)
``` bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

### Terraform
``` Hcl
// AWS 서비스 실행
$ terraform init
$ terraform plan
$ terraform apply
...
Enter a value: yes

// AWS 서비스 삭제
$ terraform destroy
...
Enter a value: yes
```

### EC2 Master / Jenkins Password
``` bash
// 컨테이너로 젠킨스를 Pull을 했기 때문에 초기 비밀번호 확인법은 조금 다르다.
// Container NAMES Checking

$ sudo docker ps -a

// 비밀번호 확인

$ sudo docker logs [Container NAMES]
...
Jenkins initial setup is required. An admin user has been created and a password generated.
Please use the following password to proceed to installation:

a768ea935............ [초기 비밀번호]

This may also be found at: /var/jenkins_home/secrets/initialAdminPassword
...

// 젠킨스 서버 접속
[Master EC2 Public IP:8080]
```
