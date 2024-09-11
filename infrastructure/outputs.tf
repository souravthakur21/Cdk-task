output "service_a_public_ip" {
  value = aws_instance.service_a.public_ip
}

output "service_b_public_ip" {
  value = aws_instance.service_b.public_ip
}

output "service_a_dns" {
  value = aws_route53_record.service_a_dns.name
}

output "service_b_dns" {
  value = aws_route53_record.service_b_dns.name
}
