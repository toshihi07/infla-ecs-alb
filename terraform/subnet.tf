# パブリックサブネット（ALB配置などで使う）
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id   # 関連付けるVPCのID
  cidr_block              = "10.0.0.0/24"     # AZ a 用のサブネットCIDR
  availability_zone       = "ap-northeast-1a" # 東京リージョンのAZ a
  map_public_ip_on_launch = true              # インスタンス起動時に自動でパブリックIPを付与

  tags = {
    Name = "public-subnet-a"
  }
}

resource "aws_subnet" "public_c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24" # AZ c 用のサブネットCIDR
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-c"
  }
}

# プライベートサブネット（ECSタスクを配置する）
resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24" # AZ a 用のプライベートサブネット
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "private-subnet-a"
  }
}

resource "aws_subnet" "private_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24" # AZ c 用のプライベートサブネット
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "private-subnet-c"
  }
}

