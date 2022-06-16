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

output "private_ip_addr" {
  value       = "${module.ec2_instance.private_ip}"
   description = "The private IP address of the main server instance."
}

output "public_ip_addr" {
  value       = "${module.ec2_instance.public_ip}"
   description = "The public IP address of the main server instance."
}

output "primary_network_interface_id" {
  value       = "${module.ec2_instance.primary_network_interface_id}"
  description = "The Subnet ID of the main server instance."
}