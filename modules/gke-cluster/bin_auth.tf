# Since we sometimes use ADCs, and since the binaryauthorization API does not
# allow ADCs, we need a dedicated SA to manage binary auth. See GPII-3860.
#
# We can't use 'count' to only include this sometimes because the
# 'google-beta.bin-auth' provider requires this resource (and provider blocks
# do not support 'count').
data "google_service_account_access_token" "bin-auth" {
  provider = "google-beta"

  target_service_account = "gke-cluster-bin-auth@${var.project_id}.iam.gserviceaccount.com"
  scopes                 = ["cloud-platform"]
  lifetime               = "300s"
}

provider "google-beta" {
  alias        = "bin-auth"
  access_token = "${data.google_service_account_access_token.bin-auth.access_token}"
}

resource "google_binary_authorization_policy" "policy" {
  count    = "${var.enable_binary_authorization ? 1 : 0}"
  provider = "google-beta.bin-auth"
  project  = "${var.project_id}"

  default_admission_rule {
    evaluation_mode  = "${var.binary_authorization_evaluation_mode}"
    enforcement_mode = "${var.binary_authorization_enforcement_mode}"
  }

  # Each `admission_whitelist_patterns` block supports only one `name_pattern`.
  # To specify multiple patterns, we must specify multilple
  # `admission_whitelist_patterns` blocks.
  #
  # This set of patterns provide some slots for module users to specify their
  # custom patterns. It would be nice to use something like
  # https://www.terraform.io/docs/configuration/expressions.html#dynamic-blocks
  # but they are not available in Terraform 0.11 :(.
  #
  # Patterns cannot be empty, so we'll use a placeholder value that satisfies Google's API.

  admission_whitelist_patterns {
    name_pattern = "${length(var.binary_authorization_admission_whitelist_patterns) > 0 ? element(var.binary_authorization_admission_whitelist_patterns, 0) : "PLACE.HOLDER/PATTERN"}"
  }
  admission_whitelist_patterns {
    name_pattern = "${length(var.binary_authorization_admission_whitelist_patterns) > 1 ? element(var.binary_authorization_admission_whitelist_patterns, 1) : "PLACE.HOLDER/PATTERN"}"
  }
  admission_whitelist_patterns {
    name_pattern = "${length(var.binary_authorization_admission_whitelist_patterns) > 2 ? element(var.binary_authorization_admission_whitelist_patterns, 2) : "PLACE.HOLDER/PATTERN"}"
  }
  admission_whitelist_patterns {
    name_pattern = "${length(var.binary_authorization_admission_whitelist_patterns) > 3 ? element(var.binary_authorization_admission_whitelist_patterns, 3) : "PLACE.HOLDER/PATTERN"}"
  }
  admission_whitelist_patterns {
    name_pattern = "${length(var.binary_authorization_admission_whitelist_patterns) > 4 ? element(var.binary_authorization_admission_whitelist_patterns, 4) : "PLACE.HOLDER/PATTERN"}"
  }
  admission_whitelist_patterns {
    name_pattern = "${length(var.binary_authorization_admission_whitelist_patterns) > 5 ? element(var.binary_authorization_admission_whitelist_patterns, 5) : "PLACE.HOLDER/PATTERN"}"
  }
  admission_whitelist_patterns {
    name_pattern = "${length(var.binary_authorization_admission_whitelist_patterns) > 6 ? element(var.binary_authorization_admission_whitelist_patterns, 6) : "PLACE.HOLDER/PATTERN"}"
  }
  admission_whitelist_patterns {
    name_pattern = "${length(var.binary_authorization_admission_whitelist_patterns) > 7 ? element(var.binary_authorization_admission_whitelist_patterns, 7) : "PLACE.HOLDER/PATTERN"}"
  }

  # This set of patterns is for Helm.

  admission_whitelist_patterns {
    name_pattern = "gcr.io/kubernetes-helm/*"
  }

  # This set of patterns covers "system" images that are included in neither
  # of Google's provided lists (short or full; see below).

  admission_whitelist_patterns {
    name_pattern = "gcr.io/gke-release/istio/*"
  }
  admission_whitelist_patterns {
    name_pattern = "gcr.io/istio-release/*"
  }
  admission_whitelist_patterns {
    name_pattern = "gcr.io/projectcalico-org/*"
  }
  admission_whitelist_patterns {
    name_pattern = "k8s.gcr.io/fluentd-gcp-scaler:*"
  }
  admission_whitelist_patterns {
    name_pattern = "quay.io/prometheus/prometheus*"
  }
  # This set of patterns covers Google-provided system images. It would be nice
  # to use the `globalPolicyEvaluationMode` field in the API
  # (https://cloud.google.com/binary-authorization/docs/reference/rest/v1/Policy)
  # but the google provider doesn't support it :(.
  #
  # These patterns come from the short list at
  # https://cloud.google.com/binary-authorization/docs/configuring-policy-cli#global_policy_evaluation_mode.
  #
  # Alternately, use the full list associated with
  # `globalPolicyEvaluationMode`. From the Dashboard: Security -> Binary
  # Authorization -> Edit Policy -> next to "Trust all Google-provided system
  # images" -> View Details.
  admission_whitelist_patterns {
    name_pattern = "gcr.io/google_containers/*"
  }
  admission_whitelist_patterns {
    name_pattern = "gcr.io/google-containers/*"
  }
  admission_whitelist_patterns {
    name_pattern = "k8s.gcr.io/*"
  }
  admission_whitelist_patterns {
    name_pattern = "gcr.io/stackdriver-agents/*"
  }
}

resource "null_resource" "check_length_binary_authorization_admission_whitelist_patterns" {
  count                                                                               = "${length(var.binary_authorization_admission_whitelist_patterns) > 8 ? 1 : 0}"
  "ERROR: binary_authorization_admission_whitelist_patterns can only have 8 elements" = true
}
