# AWS-Terraform-Docker-Binary-install

## 현 프로젝트의  목표
```
1. Terraform apply시 AWS EC2인프라 구축
2. 구축 완료시 3개의 EC2 Localtime Seoul로 자동 변경
3. 3개 EC2에 도커 바이너리를  사용하여 설치
4. 내부 통신망만 사용가능한  AWS 인프라 구축
5. provisioner "file"을 사용하여 Local->EC2 원격으로 Docker binary 전송

```
## ifconfig
```
ifconfig.me
``` 

## Docker Binary Download
``` html
https://download.docker.com/linux/static/stable/x86_64/
```

## Terraform을 이용한 AWS EC2 서비스 내 도커 및 젠킨스 컨테이너 Pull IaC 현재 젠킨스 install 주석 처리
```
Terraform version : 1.5.0
aws-cli version : 2.12.3
python version : 3.11.4
Jenkins Container : -
Docker : -
```

## AWS CLI Install
### Linux Install
``` bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```
### Windows Install
``` bash
msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi

// 설치 후 버전 확인
aws --version
```

## AWS Configuration
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

## Terraform install (Ubuntu)
``` bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

## Terraform
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

## EC2 Master / Jenkins Password
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
