# NAT Gateway用のElastic IP（EIP）を作成
resource "aws_eip" "nat_eip" {
  domain = "vpc" # VPC向けEIPであることを明示
  tags = {
    Name = "nat-eip"
  }
}

# NAT Gateway本体を作成（Publicサブネットに設置）
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id     # 上記で作成したEIPを紐付け
  subnet_id     = aws_subnet.public_a.id # NAT GatewayはPublic Subnet上に設置

  tags = {
    Name = "nat-gateway"
  }

  depends_on = [aws_internet_gateway.igw] # IGWの作成後に実行するよう明示
}

