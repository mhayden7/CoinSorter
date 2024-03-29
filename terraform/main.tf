locals {
  config = yamldecode(file("../env-config.yaml"))
}

provider "aws" {
  region = var.region == "primary" ? local.config.primary_region : local.config.secondary_region
  default_tags {
    tags = {
      project = local.config.project
    }
  }
}

module "lab_1" {
  count  = var.lab_id >= 1 ? 1 : 0

  source = "./modules/lab_1"
  region = var.region
}

module "lab_2" {
  count         = var.lab_id >= 2 ? 1 : 0

  source        = "./modules/lab_2"
  region        = var.region
  event_bus_name = module.lab_1[0].event_bus_name
}