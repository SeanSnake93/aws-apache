# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@@@@ Prerequesits ~ START @@@@@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

# Run ~/-Crosswave-Technology/Step1.sh

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@@@@@ Prerequesits ~ END @@@@@@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

provider "aws" {
  # version                 = "~> 2.8"
  region                  = var.aws_location
  shared_credentials_file = "./../../../.aws/credentials"
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@ Key Pair for machine Access @@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

resource "aws_key_pair" "key_pair" {
  key_name   = "AccessKey"
  public_key = file("~/.ssh/AccessKey.pub")
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@ Create Virtual Priv Network @@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

module "vpc" {
  source  = "./VPC"
  v4_cidr = "126.157.0.0/16"
  hostname = true

  # @@@ TAGS @@@
  name_tag = "Apache-Cloud"
  network_tag = "Apache"
}

module "igw" {
  source = "./IGW"
  vpc_id = module.vpc.id

  # @@@ TAGS @@@
  name_tag    = "Apache_Network_Gate"
  network_tag = "Apache"
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "subnet_main" {
  source  = "./SUBNET"
  availability_zone = data.aws_availability_zones.available.names[0]
  v4_cidr = "126.157.10.0/24"
  pub_ip  = true
  vpc_id  = module.vpc.id

  # @@@ TAGS @@@
  name_tag    = "Apache_Subnet"
  network_tag = "Apache"
}

module "public_routes" {
  source  = "./ROUTES"
  vpc_id  = module.vpc.id
  v4_cidr = "0.0.0.0/0"
  igw_id  = module.igw.id

  # @@@ TAGS @@@
  name_tag    = "Apache-Routes"
  network_tag = "Apache"
}

module "public_routes_association" {
  source    = "./ROUTES/ASSOCIATION"
  table_id  = module.public_routes.id
  subnet_id = module.subnet_main.id
}

# iam user

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@@@@ Create Security Group @@@@@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

module "sg" {
  source         = "./SG"
  sg_description = "This Security Group is created to allow various port access to an instance."
  vpc_id         = module.vpc.id
  port_desc      = {
    22 = "SSH-Port"
    80 = "Open-HTTP-Access"
    }
  in_port        = [22, 80]
  in_cidr        = "0.0.0.0/0"
  out_port       = 0
  out_protocol   = "-1"
  in_protocol    = "tcp"
  out_cidr       = "0.0.0.0/0"

  # @@@ TAGS @@@
  name_tag = "port_access"
  network_tag = "Apache"
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @@@@@@@ Create EC2 Instance @@@@@@@
# @@@@@@@       Manager       @@@@@@@
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

module "ec2_Apache" {
  source         = "./EC2"
  instance_count = "1"
  ami_code       = "ami-08bac620dc84221eb" # Ubuntu 20.04
  type_code      = "t2.micro"            # 1 x CPU + 1 x RAM
  pem_key        = "AccessKey"
  subnet         = module.subnet_main.id
  vpc_sg         = [module.sg.id]
  pub_ip         = true
  lock           = var.locked
  user_data      = templatefile("./../../scripts/instance/ec2.sh", {})

  # @@@ TAGS @@@
  name_tag = "Apache"
  network_tag = "Apache"
}