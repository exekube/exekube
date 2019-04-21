provider "local" {}

resource "null_resource" "helmfile_sync" {
  triggers {
    helmfile_checksum = "${filesha512("${path.root}/${var.helmfile_path}")}"
  }

  provisioner "local-exec" {
    command = <<EOF
helmfile --quiet --file ${path.root}/${var.helmfile_path} \
  --environment ${var.helmfile_environment} \
  sync
EOF
  }
}

resource "null_resource" "helmfile_destroy" {
  count = "${var.prevent_destroy ? 0 : 1}"

  provisioner "local-exec" {
    when       = "destroy"
    on_failure = "continue"

    command = <<EOF
helmfile --quiet --file ${path.root}/${var.helmfile_path} \
  --environment ${var.helmfile_environment} \
  destroy
EOF
  }
}
