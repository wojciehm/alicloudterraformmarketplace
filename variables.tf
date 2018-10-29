######### Access Key ###############
variable "access_key" {
	  type = "string"
	  default = "XXXXXXXXXX"
}
variable "secret_key" {
	  type = "string"
	  default = "XXXXXXXXX"
}
variable "region" {
	  type = "string"
	  default = "eu-central-1"
}
################# VPC ############
variable "vpc_id"{
		description = "The VPC ID to launch vSwitch"
		default = ""
}
variable "vpc_name"{
		description = "VPC Name is TF"
		default = "TerraformVPC"
}
variable "vpc_cidr" {
		default  = "172.16.0.0/12"
}	
variable "vpc_region" {
		default = "eu-central-1"
}
variable "vpc_availability_zone"{
		default = "eu-central-1a"
}
########### vswitch ################
variable "vswitch_id" {
	  description = "The vswitch id used to launch one or more instances."
	  default     = ""
}
variable "vswitch_name" {
	  description = "The vswitch name used to launch a new vswitch."
	  default     = "TF_VSwitch"
}
variable "vswitch_cidr" {
	  description = "The cidr block used to launch a new vswitch."
	  default     = "172.16.1.0/24"
}
############### SG ##################
variable "security_group" {
		default = "terraform_SG"
}
############  Image ######################
variable "count" {
  default = "1"
}
variable "count_format" {
  default = "%02d"
}
variable "most_recent" {
  default = true
}
variable "image_owners" {
  default = "marketplace"
}
variable "name_regex" {
  default = "^Magento*"
}
variable "role" {
  default = "magento"
}
variable "datacenter" {
  default = "Frankfurt"
}
variable "ecs_type" {
  default = "ecs.sn2ne.large"
}
variable "ecs_password" {
  default = "test12345"
}
variable "availability_zones" {
  default = "eu-central-1a"
}
variable "internet_charge_type" {
  default = "PayByTraffic"
}
variable "internet_max_bandwidth_out" {
  default = 1
}
variable "disk_category" {
  default = "cloud_ssd"
}
variable "disk_size" {
  default = "40"
}
variable "ecs_id" {
	default = "m-gw8azd6ceetnqxll05o7"
}
################# RDS ############################
variable "engine" {
  default = "MySQL"
}

variable "engine_version" {
  default = "5.6"
}

variable "instance_class" {
  default = "rds.mysql.t1.small"
}

variable "storage" {
  default = "10"
}

variable "net_type" {
  default = "Intranet"
}

variable "user_name" {
  default = "rdsaccount"
}

variable "password" {
  default = "Test12345"
}

variable "database_name" {
  default = "blah"
}

variable "database_character" {
  default = "utf8"
}
