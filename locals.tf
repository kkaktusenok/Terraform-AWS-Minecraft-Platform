locals {
  name = "${var.project}-${random_id.suffix.hex}"

  tags = {
    Project     = var.project
    ManagedBy   = "terraform"
    Environment = "prod"
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}