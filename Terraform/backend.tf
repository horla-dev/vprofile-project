terraform {
  backend "s3" {
    bucket = "backendtt"
    key    = "terraform/backend"
    region = "us-east-1"

  }
}