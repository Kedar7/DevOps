# Example remote state backend (S3). Replace bucket and region.
terraform {
  backend "s3" {
    bucket = "<YOUR_TFSTATE_BUCKET>"
    key    = "terraform/aws/terraform.tfstate"
    region = "<YOUR_REGION>"
  }
}
