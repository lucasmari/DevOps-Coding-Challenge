variable "project_name" {
  default = "flask-meds"
}

variable "region" {
  default = "us-east-1"
}

variable "tags" {
  default = {
    Environment = "dev",
    Project     = "flask-meds",
    Terraform   = true
  }
}
