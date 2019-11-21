# backend configuration filled by terraform init -backend-config="bucket=<nameofbucket>" -backend-config="prefix=terraform/state"
terraform {
 backend "gcs" {}
}