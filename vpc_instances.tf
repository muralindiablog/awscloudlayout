resource "aws_instance" "natinstance" {
   # count = "1"
    ami             = "ami-00a9d4a05375b2763"
    instance_type   = "t2.micro"
  #  subnet_id       = "${aws_vpc.devvpc.id}"
  #  subnet_id       =  "${aws_subnet.dev_public.*.id}"

  # The count index value can be used to decide which subnet id the instance should be
  # created, which inturn decide which availability zone we need to place the instance.

    #subnet_id       = "${element(aws_subnet.dev_public.*.id,count.index+1)}"
    subnet_id       = "${element(aws_subnet.dev_public.*.id,1)}"
    source_dest_check  = "0"
    key_name        = "DevOps"
    vpc_security_group_ids  = ["${aws_security_group.natsg.id}"]
    tags = {
        Name = "Natinstance"
    }
}
