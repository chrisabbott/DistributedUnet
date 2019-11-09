provider "aws" {
  version = "~> 2.0"
  region = "${var.aws-region}"
}

resource "aws_autoscaling_group" "training-cluster" {
  name                 = "training-cluster"
  availability_zones   = "${split(", ", var.training-cluster-az)}"
  max_size             = "${var.capacity-max}"
  min_size             = "${var.capacity-min}"
  desired_capacity     = "${var.capacity-desired}"
  launch_configuration = "${aws_launch_configuration.training-cluster.name}"
}

resource "aws_launch_configuration" "training-cluster" {
  name            = "training-cluster"
  image_id        = "${var.ubuntu-dl-base-ami}"
  instance_type   = "${var.instance-type}"
  security_groups = ["${aws_security_group.default.id}"]
  key_name        = "${var.key_name}"
}

resource "aws_security_group" "default" {
  name        = "ssh-http-open-outbound"
  description = "Used in the terraform"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
