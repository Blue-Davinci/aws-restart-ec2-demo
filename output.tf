output "instance_id" {
  value = aws_instance.restart-web.id
}

output "instance_public_id" {
  value = aws_instance.restart-web.public_ip
}

output "instance_url" {
  value = "http://${aws_instance.restart-web.public_dns}"
}