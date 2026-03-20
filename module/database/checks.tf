# File: /database/checks.tf
# Purpose: Verify RDS is actually available after deploy

check "rds_available" {
   data "aws_db_instance" "verify" {
    db_instance_identifier = aws_db_instance.mysql.identifier
  }

   assert {
      condition     = data.aws_db_instance.verify.endpoint != ""
      error_message =  "RDS endpoint is empty — database may not be available!"
   } 
}

