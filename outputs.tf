# outputs.tf

output "public_ip" {
  value       = aws_instance.minecraft.public_ip
  description = "Публичный IP сервера Minecraft"
}

output "ssh_command" {
  value       = "ssh -i ~/.ssh/minecraft-${random_id.suffix.hex}.pem ubuntu@${aws_instance.minecraft.public_ip}"
  description = "Готовая команда для подключения"
}

output "key_location" {
  value       = local_file.private_key_pem.filename
  description = "Путь до приватного ключа"
}