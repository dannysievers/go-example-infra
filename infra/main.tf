resource "google_container_cluster" "gke" {
  name     = "gke-go-api"
  location = "us-central1"
  project  = var.gcp_project_id
  provider = google-beta

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  master_auth {
    username = ""
    password = ""
  }

  addons_config {
    http_load_balancing {
      disabled = false
    }

    horizontal_pod_autoscaling {
      disabled = false
    }

    # kubernetes_dashboard {
    #   disabled = false
    # }

    network_policy_config {
      disabled = false
    }

    istio_config {
      disabled = false
    }
  }

  network_policy {
    enabled = "true"
    provider = "CALICO"
  }

  pod_security_policy_config {
    enabled = true
  }

  vertical_pod_autoscaling {
    enabled = true
  }
}

resource "google_container_node_pool" "gke_preemptible_nodes" {
  name       = "go-api-node-pool"
  location   = "us-central1"
  cluster    = google_container_cluster.gke.name
  initial_node_count = 1

  management { 
    auto_repair = "true"
    auto_upgrade = "true"
  }

  autoscaling { 
    min_node_count = 1
    max_node_count = 3
  }

  node_config {
    machine_type = "n1-standard-1"
    preemptible = true

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only"
    ]
  }
}