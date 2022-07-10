output "public_ip" {
  value = "aws_instance.instance.public_ip"
}

output "ansible_command" {
  value = "ansible-playbook -i localhost, -c local ./main.yml"
}