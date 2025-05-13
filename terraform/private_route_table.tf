# プライベートサブネット用のルートテーブル
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"               # 外部通信はすべて
    nat_gateway_id = aws_nat_gateway.nat_gw.id # NAT Gatewayを経由
  }

  tags = {
    Name = "private-route-table"
  }
}

# プライベートサブネット a にルートテーブルを関連付け
resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private.id
}

# プライベートサブネット c にルートテーブルを関連付け
resource "aws_route_table_association" "private_c" {
  subnet_id      = aws_subnet.private_c.id
  route_table_id = aws_route_table.private.id
}

