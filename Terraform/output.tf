
output "JenkinsPrivIP" {
  description = "Jenkins private ip"
  value       = aws_instance.jenkins.private_ip
}

output "JenkinsPublicIP" {
  description = "Jenkins public ip"
  value       = aws_instance.jenkins.public_ip
}

output "sonarPublicIP" {
  description = "sonar public ip"
  value       = aws_instance.sonar.public_ip
}

output "sonarPrivateIP" {
  description = "sonar private ip"
  value       = aws_instance.sonar.private_ip
}