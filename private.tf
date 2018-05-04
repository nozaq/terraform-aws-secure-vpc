#---------------------------------------------------------------------------------------------------
# Configurations for private subnets
#---------------------------------------------------------------------------------------------------

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.this.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.gw.id}"
  }

  tags = "${var.tags}"
}

resource "aws_main_route_table_association" "default_to_private" {
  vpc_id         = "${aws_vpc.this.id}"
  route_table_id = "${aws_route_table.private.id}"
}
