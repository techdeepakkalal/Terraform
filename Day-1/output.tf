 output "Public_IP" {
value = aws_instance.name.public_ip
 }

output "Private_IP" {
  value = aws_instance.name.private_ip
}
