# 

# ALB Module Creation
resource "aws_lb" "alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  security_groups    = [var.alb_sg_id]
  tags = {
    Name = var.alb_name
    Terraform = "true"
    Environment = var.env_name
  }
}

# ================================================================
# ----------------- ALB Listener Start ---------------------------
# ================================================================
# Redirection rule for all HTTP to HTTPS
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "redirect"
    redirect {
      protocol         = "HTTPS"
      port             = "443"
      status_code      = "HTTP_301"
      query            = "#{query}"
      host             = "#{host}"
      path             = "/#{path}"
    }
  }
  tags = {
    Name = var.alb_name
    Terraform = "true"
    Environment = var.env_name
  }
}

# HTTPS Listener
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = element(values(aws_lb_target_group.tg), 0).arn
  }
  tags = {
    Name = var.alb_name
    Terraform = "true"
    Environment = var.env_name
  }
}
# ================================================================
# ----------------- ALB Listener End -----------------------------
# ================================================================


# ================================================================
# ----------------- ALB Target Groups Start -----------------------
# ================================================================

# resource "aws_lb_target_group" "tg" {
#   name     = "${var.global_prefix}-${var.env_name}-f-login-tg"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = var.vpc_id
#   tags = {
#     Name = "${var.global_prefix}-${var.env_name}-f-login-tg"
#     Terraform = "true"
#     Environment = var.env_name
#   }
# }
resource "aws_lb_target_group" "tg" {
  for_each = { for tg in var.target_groups : tg.name => tg }

  name     = "${var.global_prefix}-${var.env_name}-${each.value.name}-tg"
  port     = each.value.lb_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  tags = {
    Name        = "${var.global_prefix}-${var.env_name}-${each.value.name}-tg"
    Terraform   = "true"
    Environment = var.env_name
  }
}


# ================================================================
# ----------------- ALB Target Groups End -------------------------
# ================================================================




# ================================================================
# ----------------- ALB Target Group Attachment Start -------------
# ================================================================
# resource "aws_lb_target_group_attachment" "tg_attachment" {
#   target_group_arn = aws_lb_target_group.tg.arn
#   target_id        = var.instance_id
#   port             = 80
# }
resource "aws_lb_target_group_attachment" "tg_attachment" {
  for_each = { for tg in var.target_groups : tg.name => tg }

  target_group_arn = aws_lb_target_group.tg[each.key].arn
  target_id        = var.instance_id
  port             = each.value.instance_port
}


# ================================================================
# ----------------- ALB Target Group Attachment End ---------------
# ================================================================





# ================================================================
# ----------------- ALB Listener Rule Start -----------------------
# ================================================================
# resource "aws_lb_listener_rule" "lb_listener_rule" {
#   for_each = { for tg in var.target_groups : tg.name => tg }

#   listener_arn = aws_lb_listener.https.arn
#   priority     = each.value.priority    # Use the priority from target_groups

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.tg[each.key].arn
#   }

#   dynamic "condition" {
#     for_each = can(index(each.value, "path_patterns")) ? [1] : []
#     content {
#       path_pattern {
#         values = each.value.path_patterns
#       }
#     }
#   }

#   dynamic "condition" {
#     for_each = can(index(each.value, "host")) ? [1] : []
#     content {
#       host_header {
#         values = [each.value.host]
#       }
#     }
#   }

#   dynamic "condition" {
#     for_each = can(index(each.value, "path_patterns")) && can(index(each.value, "host")) ? [1] : []
#     content {
#       path_pattern {
#         values = each.value.path_patterns
#       }
#       host_header {
#         values = [each.value.host]
#       }
#     }
#   }

#   tags = {
#     Name        = "${var.global_prefix}-${var.env_name}-${each.value.name}-listener-rule"
#     Terraform   = "true"
#     Environment = var.env_name
#   }
# }



# ================================================================
# ----------------- ALB Listener Rule End -------------------------
# ================================================================