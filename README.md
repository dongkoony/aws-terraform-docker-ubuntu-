# AWS-Terraform-Docker-install

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
// AWS Access Key, Private Key 구성
aws configure

// 설정
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
