# ECSクラスターを作成
resource "aws_ecs_cluster" "main" {
  name = "my-cluster"
}

# タスク定義（Dockerイメージ指定）
resource "aws_ecs_task_definition" "api_task" {
  family                   = "api-task"
  requires_compatibilities = ["FARGATE"]              # Fargateで起動
  network_mode             = "awsvpc"                 # Fargateでは必須
  cpu                      = "256"                    # 0.25 vCPU（最小構成）
  memory                   = "512"                    # 512MB
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn  # 簡易化のため同じに

  container_definitions = jsonencode([
    {
      name      = "api-container"
      image     = "081670647694.dkr.ecr.ap-northeast-1.amazonaws.com/toshihi-repository:latest"
      portMappings = [
        {
          containerPort = 8080
          protocol      = "tcp"
        }
      ]
    }
  ])
}

# ECSサービスの作成（ALB連携、初期タスク数2）
resource "aws_ecs_service" "api_service" {
  name            = "api-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.api_task.arn
  launch_type     = "FARGATE"
  desired_count   = 2

  network_configuration {
    subnets         = [aws_subnet.private_a.id, aws_subnet.private_c.id]  # プライベートサブネット
    security_groups = [aws_security_group.ecs_sg.id]                      # ECS用SG
    assign_public_ip = false                                              # NAT越しで通信
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.api_tg.arn
    container_name   = "api-container"
    container_port   = 8080
  }

  depends_on = [aws_lb_listener.api_listener]  # ALBのリスナーが先に必要
}

