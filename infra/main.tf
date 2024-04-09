terraform {
  backend "s3" {
    bucket = "flask-meds-state"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {
}

# Only for local testing
# data "external" "myip" {
#   program = ["bash", "-c", "curl -s 'https://api.ipify.org?format=json'"]
# }

data "template_file" "ec2_startup" {
  template = file("./scripts/ec2_startup.tpl")
  vars = {
    branch_name = var.branch_name
    db_address  = module.rds.db_instance_endpoint
  }
}

#-------------------------------------------------
#               ===== [ EC2 ] =====               
#-------------------------------------------------

# Only for local testing
# resource "aws_key_pair" "ubuntu" {
#   key_name   = "ubuntu-key"
#   public_key = file("~/.ssh/aws.pub")
# }

module "ec2_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.project_name}-ec2-sg"
  vpc_id = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    # {
    #   rule        = "ssh-tcp"
    #   cidr_blocks = "${data.external.myip.result.ip}/32"
    # },
    {
      from_port   = 5000
      to_port     = 5000
      protocol    = "tcp"
      cidr_blocks = var.all_cidr
      description = "Flask app"
    },
    {
      from_port   = 5601
      to_port     = 5601
      protocol    = "tcp"
      cidr_blocks = var.all_cidr
      description = "Kibana"
  }]

  egress_rules = ["all-all"]

  tags = var.tags
}

module "ec2" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = var.project_name

  ami                         = "ami-080e1f13689e07408" # ubuntu 22.04
  vpc_security_group_ids      = [module.ec2_sg.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  instance_type               = "t3.small"

  # key_name  = aws_key_pair.ubuntu.key_name
  user_data                   = data.template_file.ec2_startup.rendered
  user_data_replace_on_change = true

  depends_on = [
    module.rds
  ]

  root_block_device = [
    {
      encrypted   = false
      volume_type = "gp3"
      throughput  = 200
      volume_size = 50
    },
  ]

  tags = var.tags
}

#-------------------------------------------------
#               ===== [ RDS ] =====               
#-------------------------------------------------

module "rds_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.project_name}-rds-sg"
  vpc_id = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      rule                     = "postgresql-tcp"
      source_security_group_id = module.ec2_sg.security_group_id
    },
  ]

  tags = var.tags
}

module "rds" {
  source = "terraform-aws-modules/rds/aws"

  identifier = var.project_name

  create_db_option_group    = false
  create_db_parameter_group = false
  create_db_subnet_group    = true

  engine               = "postgres"
  engine_version       = "16.1"
  family               = "postgres16"
  major_engine_version = "16"
  instance_class       = "db.t3.micro"

  allocated_storage           = 5
  manage_master_user_password = false

  db_name  = "medications"
  username = "postgres"
  password = "postgres"
  port     = 5432

  subnet_ids             = module.vpc.private_subnets
  vpc_security_group_ids = [module.rds_sg.security_group_id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  backup_retention_period = 0

  performance_insights_enabled = true

  tags = var.tags
}

#-------------------------------------------------
#               ===== [ VPC ] =====               
#-------------------------------------------------

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = var.project_name
  cidr                 = var.vpc_cidr
  azs                  = data.aws_availability_zones.available.names
  public_subnets       = [var.public_subnet_cidr]
  private_subnets      = var.private_subnets_cidr
  enable_nat_gateway   = false
  single_nat_gateway   = false
  enable_dns_hostnames = true
  tags                 = var.tags
}
