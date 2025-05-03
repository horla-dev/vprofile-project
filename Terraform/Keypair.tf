resource "aws_key_pair" "jenkins-key" {
  key_name   = "jenkins-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPMKl4n27aWNnlxKFcNYudamGJ5pqanvtg1jLyvw5ZbD horla@Olaniyis-MacBook-Pro.local"
}