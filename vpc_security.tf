resource "aws_security_group" "natsg" {
    name = "NAT instance SG" 
 description = "nat sg"
   # vpc_id = "${data.aws_subnet.devpri_1.vpc_id}"
     vpc_id = "${aws_vpc.devvpc.id}"
    ingress  {
        from_port   = "${var.natsgport1}"
        to_port     = "${var.natsgport1}"
        protocol    = "tcp"
       # cidr_blocks = ["${element(aws_subnet.dev_private.*.id,1)},${element(aws_subnet.dev_private.*.id,2)}"]
       #cidr_blocks = ["0.0.0.0/0"]
       cidr_blocks = ["${data.aws_subnet.devpri_1.cidr_block}", "${data.aws_subnet.devpri_2.cidr_block}", "${data.aws_subnet.devpri_3.cidr_block}"] 
    }
    ingress  {
        from_port   = "${var.natsgport2}"
        to_port     = "${var.natsgport2}"
        protocol    = "tcp"
       cidr_blocks = ["${data.aws_subnet.devpri_1.cidr_block}", "${data.aws_subnet.devpri_2.cidr_block}", "${data.aws_subnet.devpri_3.cidr_block}"] 
    }
    ingress  {
        from_port   = "${var.natsgport3}"
        to_port     = "${var.natsgport3}"
        protocol    = "tcp"
       cidr_blocks = ["${data.aws_subnet.devpri_1.cidr_block}", "${data.aws_subnet.devpri_2.cidr_block}", "${data.aws_subnet.devpri_3.cidr_block}"] 
    }
    egress  {
        from_port   = "80"
        to_port     = "80"
	description = "HTTP"
	#ipv6_cidr_blocks = "null" 
	#prefix_list_ids = ["null"]
	#self = "null"
	#security_groups = "null"
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
	from_port   = "443"
        to_port     = "443"
	description = "HTTPS"
	#ipv6_cidr_blocks = "null"
	#prefix_list_ids = ["null"]
	#self = "null"
	#security_groups = "null"
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
   }

 
    tags = {
        Name = "TF_NAT_SG"
    }
}

