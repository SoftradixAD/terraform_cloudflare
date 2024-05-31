output "Stage_server_IP" {
  value = aws_instance.stage.public_ip
}

output "Dev_server_IP" {
  value = aws_instance.dev.public_ip
}


output "Dev_server_record" {
  value = cloudflare_record.dev.name
}

output "Stage_server_record" {
  value = cloudflare_record.stage.name
}

