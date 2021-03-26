data "aws_ami" "amazon_linux" {
  owners      = ["amazon"]
  most_recent = true


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

output "amazon_linux_ami_id" {
  value = data.aws_ami.amazon_linux.id
}

resource "aws_instance" "example-instance-cli" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"

  tags = {
    Name = "example-instance-cli"
  }


  provisioner "local-exec" {
    command    = "echo ${aws_instance.example-instance-cli.public_ip} >> inventory"
    on_failure = fail
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
  name                       = "example-vm-cli"
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
