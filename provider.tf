terraform {
  required_providers {

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.0.3"
    }

    vsphere = {
      source  = "hashicorp/vsphere"
      version = ">= 1.24.3"
    }
  }
}


provider "kubernetes" {
  config_path = "./kubeconfig.yaml"
}


provider "vsphere" {
  user                 = var.vsphere_username
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = var.unverified_ssl
}
