variable "region" {
  description = "default region"
  type        = string
  default     = "eu-central-1"
}
# ---------------------------------

variable "ec2_instance_type" {
  description = "Instance type for development"
  type        = string
  default     = "t2.nano"
}
# ---------------------------------

variable "ec2_ami" {
  description = "ubuntu-ami-eu-central-1"
  type        = string
  default     = "ami-0084a47cc718c111a"
}
# ---------------------------------

variable "port_egress" {
  description = "Egress Port Configuration allow all"
  type = object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  })
  default = {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# ---------------------------------

variable "availability_zone_spublic_subnet" {
  description = "AZ for public_subnet_eu-central-1a"
  type        = string
  default     = "eu-central-1a"
}
# ---------------------------------

variable "cidr_block_only_ones" {
  # EIN WUNDERSCHÖNER NAME
  description = "cidr_block_10.0.0.0/20"
  type        = string
  default     = "10.0.0.0/20"
}
# ---------------------------------

variable "cidr_block" {
  description = "cidr_block_0.0.0.0/0"
  type        = string
  default     = "10.0.0.0/16"
}
# ---------------------------------

variable "mysql_port" {
  description = "port for mysql, from and to port"
  type        = number
  default     = 3306
}
# ---------------------------------

variable "ssh_port" {
  description = "port for SSH, from and to port"
  type        = number
  default     = 22
}

# ---------------------------------

variable "apache_port" {
  description = "port for Apache, from and to port"
  type        = number
  default     = 80
}
