## this null resource do nothing , but we give provisioner , provisioner is one which is going to help you to connect to ec2 instances/linux instances by providing required information.It can connect to the instances and execute the commands
resource "null_resource" "app-deploy" {
  count = length(aws_spot_instance_request.ec2-spot)
  connection {
    type     = "ssh"
    user     = jsondecode(data.aws_secretsmanager_secret_version.secrets.secret_string)["username"]
    password = jsondecode(data.aws_secretsmanager_secret_version.secrets.secret_string)["password"]
    host     = aws_spot_instance_request.ec2-spot.*.private_ip[count.index]
  }
  provisioner "remote-exec" {
    inline = [
      "ansible-pull -U https://github.com/Sai-kor/ansible.git roboshop-pull.yml -e COMPONENT=${var.COMPONENT} -e ENV=${var.ENV} -e APP_VERSION=${var.APP_VERSION} -e NEXUS_USERNAME=${jsondecode(data.aws_secretsmanager_secret_version.secrets.secret_string)["
      NEXUS_USERNAME"]} -e NEXUS_PASSWORD=${jsondecode(data.aws_secretsmanager_secret_version.secrets.secret_string)["NEXUS_PASSWORD"]}"
    ]
  }
}