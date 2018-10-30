provider "alicloud" {
	  access_key = "${var.access_key}"
	  secret_key = "${var.secret_key}"
	  region     = "${var.region}"
}
##################VPC####################
resource "alicloud_vpc" "main" {
		name 				= "${var.vpc_name}"
		cidr_block 	= "${var.vpc_cidr}"
}
############## vswitch ################
resource "alicloud_vswitch" "main"{
		vpc_id 						= "${alicloud_vpc.main.id}"
		cidr_block 				= "${var.vswitch_cidr}"
	  availability_zone = "${var.vpc_availability_zone}"
	  depends_on 				= [
	  "alicloud_vpc.main",
	  ]
}
################### SG ###############
resource "alicloud_security_group" "main" {
		name		= "${var.security_group}"
		vpc_id	= "${alicloud_vpc.main.id}"
}

################## SG rules ##############

resource "alicloud_security_group_rule" "http-in" {
	  type = "ingress"
		ip_protocol = "tcp"
	  #nic_type  = "internet"
		nic_type = "intranet"
		policy = "accept"
	  port_range = "80/80"
	  priority = 1
	  security_group_id = "${alicloud_security_group.main.id}"
	  cidr_ip = "0.0.0.0/0"
	}
resource "alicloud_security_group_rule" "ssh-in" {
	  type = "ingress"
	  ip_protocol = "tcp"
	  nic_type = "intranet"
		#nic_type = "internet"
    policy = "accept"
	  port_range = "22/22"
	  priority = 1
	  security_group_id = "${alicloud_security_group.main.id}"
	  cidr_ip = "0.0.0.0/0"
}
############################Magento#######################
data "alicloud_images" "ecs_image" {
  most_recent = "${var.most_recent}"
  owners      = "${var.image_owners}"
  name_regex  = "${var.name_regex}"
}
resource "alicloud_disk" "disk" {
  availability_zone = "${var.vpc_availability_zone}"
  category          = "${var.disk_category}"
  size              = "${var.disk_size}"
  count             = "${var.count}"
}
resource "alicloud_instance" "instance" {
  instance_name     = "${var.role}"
  host_name         = "${var.role}"
  image_id					= "${var.ecs_id}"
	instance_type     = "${var.ecs_type}"
  count             = "${var.count}"
  availability_zone = "${var.vpc_availability_zone}"
	security_groups   = ["${alicloud_security_group.main.id}"]
  vswitch_id				= "${alicloud_vswitch.main.id}"
  instance_charge_type = "PostPaid"
  system_disk_category = "cloud_efficiency"

  tags {
    role = "${var.role}"
    dc = "${var.datacenter}"
  }
}
#################### EIP ###########################
resource "alicloud_eip" "eip" {}
resource "alicloud_eip_association" "attach" {
  allocation_id = "${alicloud_eip.eip.id}"
  instance_id   = "${alicloud_instance.instance.id}"
}
resource "alicloud_disk_attachment" "instance-attachment" {
  count       = "${var.count}"
  disk_id     = "${element(alicloud_disk.disk.*.id, count.index)}"
  instance_id = "${element(alicloud_instance.instance.*.id, count.index)}"
}
################### RDS ###########################
resource "alicloud_db_instance" "instance" {
  engine           = "${var.engine}"
  engine_version   = "${var.engine_version}"
  instance_type    = "${var.instance_class}"
  instance_storage = "${var.storage}"
  vswitch_id       = "${var.vswitch_id == "" ? alicloud_vswitch.main.id : var.vswitch_id}"
}
resource "alicloud_db_account" "account" {
  count       = 1
  instance_id = "${alicloud_db_instance.instance.id}"
  name        = "tf_account"
  password    = "${var.password}"
}
resource "alicloud_db_backup_policy" "backup" {
  instance_id   = "${alicloud_db_instance.instance.id}"
  backup_period = ["Tuesday", "Wednesday"]
  backup_time   = "10:00Z-11:00Z"
}
resource "alicloud_db_connection" "connection" {
  instance_id       = "${alicloud_db_instance.instance.id}"
  connection_prefix = "tf-connection"
}
resource "alicloud_db_database" "db" {
  count       = 1
  instance_id = "${alicloud_db_instance.instance.id}"
  name        = "${var.database_name}"
}
resource "alicloud_db_account_privilege" "privilege" {
  count        = 1
  instance_id  = "${alicloud_db_instance.instance.id}"
  account_name = "${element(alicloud_db_account.account.*.name, count.index)}"
  db_names     = ["${alicloud_db_database.db.*.name}"]
}
