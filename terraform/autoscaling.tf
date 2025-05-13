# ECSサービスのオートスケーリング設定（スケーリング範囲）
resource "aws_appautoscaling_target" "ecs_scaling_target" {
  max_capacity       = 4                                                                          # 最大タスク数
  min_capacity       = 2                                                                          # 最小タスク数
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.api_service.name}" # ECSのリソースID形式
  scalable_dimension = "ecs:service:DesiredCount"                                                 # スケーリング対象
  service_namespace  = "ecs"                                                                      # ECSであることを明示
}

# スケーリングポリシー（CPU使用率が50%を超えたらスケールアウト）
resource "aws_appautoscaling_policy" "cpu_scaling_policy" {
  name               = "cpu-scaling-policy"
  service_namespace  = "ecs"
  resource_id        = aws_appautoscaling_target.ecs_scaling_target.resource_id
  scalable_dimension = "ecs:service:DesiredCount"
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization" # CPU使用率を監視
    }

    target_value       = 70.0 # 50%を維持するように自動調整
    scale_in_cooldown  = 60   # スケールイン後の待機秒数
    scale_out_cooldown = 60   # スケールアウト後の待機秒数
  }
}

