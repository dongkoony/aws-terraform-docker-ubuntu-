# AWS-Terraform-Docker-install

## AWS CLI Install
### Linux Install
```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```
### Windows Install
```
msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi

// 설치 후 버전 확인
aws --version
```

## AWS Configuration
```
// AWS Access Key, Private Key 구성
aws configure

// 설정
AWS Access Key ID [None] :
AWS Secret Access Key [None] :
Default region name [None] : ap-northeast-2(서울)
Default output format [None] : json

// 등록 확인
aws configure list
```

## Terraform install (Ubuntu)
```
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

## Terraform Start
``` Hcl
$ terraform init
$ terraform plan
$ terraform apply
```
