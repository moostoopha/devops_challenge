
resource "aws_security_group" "nginx_web_interface" {
    name = "${var.r53_name}-alb-sg"
    description = "Allow nginx"
    vpc_id = "${var.vpc_id}"
    # Allow inbound HTTP requests
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Allow all outbound requests
    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_launch_configuration" "nginx_server" {
  image_id = "${var.image_id}"
  instance_type = "${var.instance_type}"
  iam_instance_profile = "${var.iam_instance_profile}"
  security_groups = ["${aws_security_group.nginx_web_interface.id}"]
  user_data = <<EOF
      #!/bin/bash
      sudo service docker start
      sudo docker pull docker/nginx/nginx:latest
      sudo docker network create -d bridge elstack
      echo 'server.name: nginx' >> /tmp/nginx.yml
      echo 'server.host: "0.0.0.0"' >> /tmp/nginx.yml
      echo 'xpack.ml.enabled: false' >> /tmp/nginx.yml
      sudo docker run -p 80:8080 -d \
        --restart unless-stopped \
        --name=nginx --network=elstack \
        -v /tmp/nginx.yml:/usr/share/nginx/config/nginx.yml \
        docker.nginx.co/nginx/nginx:7.7.0


EOF
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "nginx_asg" {
  launch_configuration = "${aws_launch_configuration.nginx_server.name}"
  vpc_zone_identifier = "${var.private_subnets}"
  target_group_arns = ["${aws_lb_target_group.asg.arn}"]
  # health_check_type = "ELB"
  min_size = 1
  max_size = 1
  # tags = "${var.tags}"
  tag {
    key = "Name"
    value = "nginx"
    propagate_at_launch = true
  }

resource "aws_lb" "nginx_alb" {
  name = "${var.r53_name}-lb"
  load_balancer_type = "application"
  subnets = "${var.public_subnets}"
  security_groups = ["${aws_security_group.nginx_web_interface.id}"]
  tags = "${var.tags}"
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = "${aws_lb.nginx_alb.arn}"
  port              = "80"
  protocol          = "HTTP"
  # By default, redirect to HTTPS
  default_action {
    type = "redirect"

  }
}


resource "aws_lb_target_group" "asg" {
  name = "${var.r53_name}-asg"
  port = 80
  protocol = "HTTP"
  vpc_id = "${var.vpc_id}"
  health_check {
    path = "/api/status"
    protocol = "HTTP"
    matcher = "200"
    interval = 60
    timeout = 10
    healthy_threshold = 5
    unhealthy_threshold = 5
  }
}

resource "aws_lb_listener_rule" "asg" {
  listener_arn = "${aws_lb_listener.http.arn}"
  priority = 100
  condition {
    field = "path-pattern"
    values = ["*"]
  }

  }
}

resource "aws_route53_record" "nginx-dns" {
  zone_id = "${var.r53_zone_id}"
  name    = "${var.r53_name}"
  type    = "CNAME"
  ttl     = "30"
  records = ["${aws_lb.nginx_alb.dns_name}"]
}

//Attach WAF Via Terraform
resource "aws_wafregional_web_acl_association" "attach_waf" {
  count = "${var.waf_web_acl_id=="" ? 0 : 1}"
  resource_arn = "${aws_lb.nginx_alb.arn}"
  web_acl_id = "${var.waf_web_acl_id}"
}