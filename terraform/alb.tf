# ALBの作成（インターネット向け、2つのAZに対応）
resource "aws_lb" "api_alb" {
  name               = "api-alb"
  load_balancer_type = "application"                   # アプリケーションロードバランサー
  subnets            = [                               # パブリックサブネットに配置
    aws_subnet.public_a.id,
    aws_subnet.public_c.id
  ]
  security_groups    = [aws_security_group.alb_sg.id]  # ALB用のSGを適用

  tags = {
    Name = "api-alb"
  }
}

# ターゲットグループの作成（ECSタスクのターゲット先）
resource "aws_lb_target_group" "api_tg" {
  name        = "api-tg"
  port        = 8080                     # ECSタスクがリッスンするポート
  protocol    = "HTTP"
  target_type = "ip"                     # Fargateでは「ip」指定が必須
  vpc_id      = aws_vpc.main.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "api-target-group"
  }
}

# リスナー（HTTP:80 → ターゲットグループへルーティング）
resource "aws_lb_listener" "api_listener" {
  load_balancer_arn = aws_lb.api_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_tg.arn
  }
}

