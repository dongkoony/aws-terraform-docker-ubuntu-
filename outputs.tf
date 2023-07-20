# 생성 후 Public UP Output
output "master_instance_ip" {
  value = aws_instance.ec2_instance_master.public_ip
}

output "node1_instance_ip" {
  value = aws_instance.ec2_instance_node1.public_ip
}

output "node2_instance_ip" {
  value = aws_instance.ec2_instance_node2.public_ip
}

  # 테스트 코드
# IAM 사용자 생성 후 Access Key Secret Access Key Output
# resource "aws_iam_user" "example_user" {
#   name = "example-user"
# }

# output "iam_access_key" {
#   value = aws_iam_user.example_user.access_key
# }
