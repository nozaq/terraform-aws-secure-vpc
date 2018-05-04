#---------------------------------------------------------------------------------------------------
# NAT Gateway
#---------------------------------------------------------------------------------------------------
resource "aws_subnet" "nat" {
  count             = "${length(var.availability_zones)}"
  vpc_id            = "${aws_vpc.this.id}"
  cidr_block        = "${var.nat_subnet_cidr_blocks[count.index]}"
  availability_zone = "${var.availability_zones[count.index]}"
  tags              = "${var.tags}"
}

resource "aws_route_table_association" "dmz" {
  count          = "${length(var.availability_zones)}"
  subnet_id      = "${aws_subnet.nat.*.id[count.index]}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_network_acl" "nat" {
  vpc_id     = "${aws_vpc.this.id}"
  subnet_ids = ["${aws_subnet.nat.id}"]

  # allow all traffic from instances inside the VPC.
  ingress {
    protocol   = "all"
    rule_no    = 100
    action     = "allow"
    cidr_block = "${var.cidr_block}"
    from_port  = 0
    to_port    = 0
  }

  # allow all returning traffic from the internet.
  ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  # allow all traffic to the internet.
  egress {
    protocol   = "all"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = "${var.tags}"
}

resource "aws_eip" "nat" {
  count = "${length(var.availability_zones)}"
  vpc   = true
  tags  = "${var.tags}"
}

resource "aws_nat_gateway" "gw" {
  count         = "${length(var.availability_zones)}"
  allocation_id = "${aws_eip.nat.*.id[count.index]}"
  subnet_id     = "${aws_subnet.nat.*.id[count.index]}"
  tags          = "${var.tags}"
}
