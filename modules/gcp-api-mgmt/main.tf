# GCP sevices aka APIs to enable for the GCP project
resource "google_project_service" "services" {
  count = "${length(var.project_services)}"

  service = "${element(var.project_services, count.index)}"

  provisioner "local-exec" {
    # TODO: Add some checks to see whether the API has been enabled by GCP,
    ## as the process can take a couple of minutes in some cases
    command = "sleep ${var.waiting_period}"
  }
}
