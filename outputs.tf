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