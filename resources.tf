resource "kubernetes_deployment" "example" {
  metadata {
    name = "terraform-example"
    labels = {
      test = "MyExampleApp"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        test = "MyExampleApp"
      }
    }

    template {
      metadata {
        labels = {
          test = "MyExampleApp"
        }
      }

      spec {
        container {
          image = "nginx:1.7.8"
          name  = "example"
        }
      }
    }
  }
}



data "vsphere_datacenter" "dc" {
  name = var.dc
}

data "vsphere_datastore" "datastore" {
  name          = var.datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_host" "host" {
  name          = var.host
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.network
  datacenter_id = data.vsphere_datacenter.dc.id
}



data "vsphere_resource_pool" "pool" {
  name          = "hci/Resources"
  datacenter_id = data.vsphere_datacenter.dc.id
}


resource "vsphere_virtual_machine" "vmFromRemoteOvf" {
  name                       = "terraform-example-vm"
  resource_pool_id           = data.vsphere_resource_pool.pool.id
  datastore_id               = data.vsphere_datastore.datastore.id
  host_system_id             = data.vsphere_host.host.id
  datacenter_id              = data.vsphere_datacenter.dc.id
  wait_for_guest_ip_timeout  = -1
  wait_for_guest_net_timeout = -1
  ovf_deploy {
    remote_ovf_url    = var.remote_ovf_url
    disk_provisioning = "thin"
    #ip_protocol          = "IPV4"
    #ip_allocation_policy = "STATIC_MANUAL"

  }
}
