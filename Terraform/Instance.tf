
resource "aws_instance" "jenkins" {
  ami                    = var.ami_by_region[var.region]
  instance_type          = "t3.large"
  key_name               = aws_key_pair.jenkins-key.key_name
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  availability_zone      = var.zone1

  root_block_device {
    volume_size = 20
  }

  tags = {
    Name    = "jenkins"
    Project = "cicd"
  }

  provisioner "file" {
    source      = "userdata/jenkins-setup.sh"
    destination = "/tmp/jenkins-setup.sh"
  }

  connection {
    type        = "ssh"
    user        = var.webuser
    private_key = file("jenkins-key")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/jenkins-setup.sh",
      "sudo /tmp/jenkins-setup.sh"
    ]
  }


}

resource "aws_ec2_instance_state" "Jenkins-state" {
  instance_id = aws_instance.jenkins.id
  state       = "running"
}


resource "aws_instance" "sonar" {
  ami                    = var.ami_by_region[var.region]
  instance_type          = "t3.large"
  key_name               = "jenkins-key"
  vpc_security_group_ids = [aws_security_group.sonar_sg.id]
  availability_zone      = var.zone1

  root_block_device {
    volume_size = 20
  }

  tags = {
    Name    = "sonar"
    Project = "cicd"
  }

  provisioner "file" {
    source      = "userdata/sonar.sh"
    destination = "/tmp/sonar.sh"
  }

  connection {
    type        = "ssh"
    user        = var.webuser
    private_key = file("jenkins-key")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/sonar.sh",
      "sudo /tmp/sonar.sh"
    ]
  }

}

resource "aws_ec2_instance_state" "sonar-state" {
  instance_id = aws_instance.sonar.id
  state       = "running"
}



