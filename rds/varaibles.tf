locals {
    rds = {
    rds_name              = "pg"
    rds_sg_name           = "rds"
    db_name               = "postgres"
    username              = "postgres"
    family                = "postgres14"
    engine                = "postgres"
    engine_version        = "14.7"
    major_engine_version  = "14"
    port                  = "5432"
    max_allocated_storage = 500
    allocated_storage     = 200
  }
}