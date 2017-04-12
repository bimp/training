#
# DO NOT DELETE THESE LINES!
#
# Your AMI ID is:
#
#     ami-eea9f38e
#
# Your subnet ID is:
#
#     subnet-b30f9ceb
#
# Your security group ID is:
#
#     sg-834d35e4
#
# Your Identity is:
#
#     autodesk-coyote
#

terraform {
  backend "atlas" {
    name = "parasb/training"
  }
}

variable "aws_access_key" {
  type = "string"
}

variable "aws_secret_key" {
  type = "string"
}

variable "aws_region" {
  default = "us-west-1"
}

variable "totalcount" {
  default = "3"
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

resource "aws_instance" "web" {
  ami                    = "ami-eea9f38e"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-b30f9ceb"
  vpc_security_group_ids = ["sg-834d35e4-parasb"]

  tags {
    Identity  = "autodesk-coyote"
    Name      = "parasb-web-instance"
    Company   = "autodesk"
    NameCount = "web ${count.index+1}/${var.totalcount}"
  }

  count = "${var.totalcount}"
}

output "public_ip" {
  # value = "${aws_instance.web.public_ip}"
  value = ["${aws_instance.web.*.public_ip}"]

  # value = "${element(aws_instance.web.*.public_ip, 0)}"
}

output "public_dns" {
  # value = "${aws_instance.web.public_dns}"
  value = ["${aws_instance.web.*.public_dns}"]

  # value = "${element(aws_instance.web.*.public_dns, 0)}"
}
