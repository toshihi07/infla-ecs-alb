# パブリックサブネット用のルートテーブル
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"                 # 全ての外部通信
    gateway_id = aws_internet_gateway.igw.id # IGW経由で通信させる
  }

  tags = {
    Name = "public-route-table"
  }
}

# パブリックサブネット a をルートテーブルに関連付け
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

# パブリックサブネット c をルートテーブルに関連付け
resource "aws_route_table_association" "public_c" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = aws_route_table.public.id
}

