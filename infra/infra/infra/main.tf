resource "google_cloud_run_service" "default" {
  name     = var.service_name
  location = var.region

  template {
    spec {
      containers {
        image = var.image_url
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  autogenerate_revision_name = true
}

resource "google_cloud_run_service_iam_member" "unauth" {
  service    = google_cloud_run_service.default.name
  location   = google_cloud_run_service.default.location
  role       = "roles/run.invoker"
  member     = "allUsers"
}

# Reserve external IP
resource "google_compute_global_address" "lb_ip" {
  name = "${var.service_name}-ip"
}

# URL map and backend service for Cloud Run
resource "google_compute_backend_service" "run_backend" {
  name                            = "${var.service_name}-backend"
  load_balancing_scheme           = "EXTERNAL_MANAGED"
  protocol                        = "HTTP"
  enable_cdn                      = false
  connection_draining_timeout_sec = 0

  backend {
    group = google_cloud_run_service.default.status[0].url
  }
}

# HTTP proxy
resource "google_compute_url_map" "url_map" {
  name            = "${var.service_name}-map"
  default_service = google_compute_backend_service.run_backend.self_link
}

resource "google_compute_target_http_proxy" "http_proxy" {
  name    = "${var.service_name}-proxy"
  url_map = google_compute_url_map.url_map.self_link
}

resource "google_compute_global_forwarding_rule" "http_forwarding_rule" {
  name       = "${var.service_name}-http-rule"
  ip_address = google_compute_global_address.lb_ip.address
  port_range = "80"
  target     = google_compute_target_http_proxy.http_proxy.self_link
}
