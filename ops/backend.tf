terraform {
  backend "s3" {
    bucket = "qa"
    key    = "test-apm-nginx/terraform.tfstate"
    region = "your-zone"

    workspace_key_prefix = "rangeof prefix"
  }
}