output "account_id" {
  value = "${data.aws_caller_identity.current.account_id}"
  description = "AWS account ID."
}

output "user_id" {
  value = "${data.aws_caller_identity.current.user_id}"
  description = "AWS user ID."
}

output "region" {
  value = "${data.aws_region.current.endpoint}"
  description = "AWS current region."
}

output "instance_ip_addr" {
  value       = aws_instance.ubuntu_netology_aws[*].private_ip
  description = "The private IP address of the main server instance."
}

output "instance_subnet_id" {
  value       = aws_instance.ubuntu_netology_aws[*].subnet_id
  description = "The Subnet ID of the main server instance."
}