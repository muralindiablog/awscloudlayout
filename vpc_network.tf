data "aws_availability_zones" "available" {}

resource "aws_vpc" "devvpc" {
    cidr_block = "${var.devvpc_cidr}"
    
    tags = {
        Name = "TNDVPC-TF"
    }
}
resource "aws_subnet" "dev_private" {
    count             = "${var.az_count}"
    cidr_block        = "${cidrsubnet(aws_vpc.devvpc.cidr_block, 4, count.index)}"
    availability_zone = "${data.aws_availability_zones.available.names[count.index+3]}"
    vpc_id            = "${aws_vpc.devvpc.id}"
    tags = {
        Name = "dev_private_${count.index+1}"
    }
}
resource "aws_subnet" "dev_public" {
    count               = "${var.pubaz_count}"
# Here we can manipulate the netnum i.e network number and assign as desired using count
    cidr_block          = "${cidrsubnet(aws_vpc.devvpc.cidr_block, 4, var.az_count+count.index+1)}"
    availability_zone   = "${data.aws_availability_zones.available.names[count.index+3]}"
    vpc_id              = "${aws_vpc.devvpc.id}"
    tags = {
        Name = "dev_public_${count.index+1}"
    }
}

data "aws_subnet" "devpri_1" {
    #count = "1"
   #id = "${element(aws_subnet.dev_private.*.id,count.index)}"
    id = "${element(aws_subnet.dev_private.*.id,0)}"
}

data "aws_subnet" "devpri_2" {
    id = "${element(aws_subnet.dev_private.*.id,1)}"
}

data "aws_subnet" "devpri_3" {
    id = "${element(aws_subnet.dev_private.*.id,2)}"
	}

output "dev_pub_subnet_id" {
	value = "${aws_subnet.dev_private.*.id}"
	}

output "pri-cidrs" {
	value = "${aws_subnet.dev_private.*.cidr_block}"
	}

########
resource "aws_internet_gateway" "tfpigw" {
    vpc_id = "${aws_vpc.devvpc.id}"
    tags = {
        Name = "TNDVPC_TF_igw"
    }
}

resource "aws_route" "devpub_internet_access" {
    route_table_id = "${aws_vpc.devvpc.main_route_table_id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.tfpigw.id}"
    }

resource "aws_route_table" "devpri_patch_internet_access" {
    vpc_id = "${aws_vpc.devvpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${aws_instance.natinstance.id}"
    }
    tags = {
        Name = "TNDVPC_TF_pri_route"
    }
}
resource "aws_eip" "tfnatinstance_eip" {
    vpc         = true
    instance    =  "${aws_instance.natinstance.id}"
    depends_on  = ["aws_internet_gateway.tfpigw"]
}



resource "aws_route_table_association" "devpri_route_for_patch" {
    count           = "${var.az_count}" 
    subnet_id       = "${element(aws_subnet.dev_private.*.id, count.index)}"
    route_table_id  = "${aws_route_table.devpri_patch_internet_access.id}"
}

