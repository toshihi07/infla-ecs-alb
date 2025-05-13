# インフラ構成管理（Terraform × ECS × ALB）

このリポジトリでは、Terraform を用いて以下の構成をコード化・自動構築します。

## 💡 構成概要

- VPC（CIDR: 10.0.0.0/21）
- パブリックサブネット ×2（ALB配置）
- プライベートサブネット ×2（ECSタスク配置）
- Internet Gateway（IGW）
- NAT Gateway（後続ステップで追加予定）
- ALB（後続ステップで追加予定）
- ECS Fargate（後続ステップで追加予定）
- ECR（手動 or Terraform）

## 📁 ディレクトリ構成
terraform/
├── main.tf
├── vpc.tf
├── subnet.tf
├── route_table.tf
├── outputs.tf

## 🔒 注意事項
- terraform/ や *.tfstate は .gitignore によりGit管理されていません
- AWS認証情報は環境変数または ~/.aws/credentials を利用してください
