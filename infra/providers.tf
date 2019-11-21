# GCP credentials provided by GOOGLE_CLOUD_KEYFILE_JSON environment variable
# GCP project provided by GOOGLE_PROJECT environment variable
provider "google-beta" {
  region  = var.gcp_region
  zone    = var.gcp_zone
}