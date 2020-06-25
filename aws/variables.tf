variable "region" {
   type = string
   default = "us-east-1"
}

variable "availability_zone_names" {
  type    = list(string)
  default = ["us-east-1a","us-east-1b","us-east-1c"]
}

variable "environment_name" {
  type = string
  default = "k8s-cluster-1"
}

variable "cidr_block" {
   type = string
   default = "10.0.0.0/16"
}

variable "private_subnets" {
    type = map
    default = {
      us-east-1a = "10.0.1.0/24"
      us-east-1b = "10.0.2.0/24"
      us-east-1c = "10.0.3.0/24"
    }
}

variable "public_subnets" {
    type = map
    default = {
      us-east-1a = "10.0.11.0/24"
      us-east-1b = "10.0.12.0/24"
      us-east-1c = "10.0.13.0/24"
    }
}

variable "image_id" {
  type = string
  default = "ami-085925f297f89fce1"
}

variable "master_instance_type" {
  type = string
  default = "t3.medium"
}


variable "worker_instance_type" {
  type = string
  default = "t3.medium"
}


variable "bastion_instance_type" {
  type = string
  default = "t2.micro"
}

variable "master_instances" {
  type = map
  default = {
  master-1 = "us-east-1a"
  master-2 = "us-east-1b"
  master-3 = "us-east-1c"
  }
}

variable "worker_instances" {
  type = map
  default = {
  worker-1 = "us-east-1a"
  worker-2 = "us-east-1b"
  worker-3 = "us-east-1c"
  }
}
