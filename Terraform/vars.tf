variable "region" {
  default = "us-east-1"
}

variable "zone1" {
  default = "us-east-1a"

}
variable "webuser" {
  default = "ubuntu"

}

variable "ami_by_region" {
  type = map(any)
  default = {
    us-east-2              = "ami-0cb91c7de36eed2cb"
    us-east-1              = "ami-0e1bed4f06a3b463d" #ubuntu
    us-east-1-amazon-linux = "ami-085ad6ae776d8f09c"
    us-east-1-centos9      = "ami-0d1d87e524772b453"
    us-west-1              = "ami-03d49b144f3ee2dc4"

  }

}