# This code is compatible with Terraform 4.25.0 and versions that are backwards compatible to 4.25.0.
# For information about validating this Terraform code, see https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build#format-and-validate-the-configuration
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.11.0"
    }
  }
}

provider "google" {
  project = "madsandbox"
}

resource "google_compute_instance" "docker-training-demo" {
  boot_disk {
    auto_delete = true
    device_name = "instance-20241112-171833"

    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-2404-noble-amd64-v20241004"
      size  = 30
      type  = "pd-balanced"
    }

    mode = "READ_WRITE"
  }

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  labels = {
    goog-ec-src = "vm_add-tf"
  }

  machine_type = "e2-standard-2"

  metadata = {
    ssh-keys       = "jklaer:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCxG38J4LgCDq6LiKfIRMxhG1giNifZmVNXsUUQsiws550IEXq59/p17RVevryKUTa1U8fz8+ATdHXAHIL/Hslj2kkBahniIoFYsAVHDBZEdbQjr88gEBanL7gaCbd7v0M7LgzVA1wRnswhr/vRXVkUSWIeAomUryLHbzJjQlCZWE5PcehFwTGu/A6njz7iXJyfFfyUkWLbYrNratNR963cU8Y5FH7Gspw24YDs/5lifBCT4kFl02u5j3YWq+HL0KkM78T6BQRqwZhcHUeR3dPLaNQCWkjzwxXzELf2SrKHfYHMs3X1kvEyBReMoWMdEZcfVv0d5b0pkdtnv1rrLytX+gtstmH2JX0VRRZihpsb9QlFss1W2R4FapcoCrxslPDvi+v9bkRoNIM2xnewZDVRd4xXrBi5Wp5U20SyRA4gIe3aCEDDXAwjNeuFBw8a/M4DhRhcod79iIozMuGZAx8gOYqzXmvfJx87M7aYru/GkRsDX6FB+4l+D6Jgq2GEwl9ekXmGmvZqN1emUyHQVXaSX36pwAlZyD6XjYTGn/2MCRVhCP/Br94QC7KIa0/tsQJHNDRsEYvAmTKZ239igcy1AqQDuSoA3COudSjUHGp0g7ButIIyBsoJflc4opCkB9/ivaJNFtTAOMKrCY7o3Ol3jy7zlRSu/WwC/L+w5a47AQ== jklaer@jklaer-XPS-13-9305"
    startup-script = " #! /bin/bash\napt update\napt install docker.io -y\nusermod -a -G docker jklaer"
  }

  name = "docker-training-demo"

  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }

    queue_count = 0
    stack_type  = "IPV4_ONLY"
    subnetwork  = "projects/madsandbox/regions/europe-west1/subnetworks/default"
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  tags = ["http-server", "https-server"]
  zone = "europe-west1-d"
}
