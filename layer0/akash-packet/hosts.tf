resource "packet_device" "hosts" {
  count            = length(keys(var.regions))
  hostname         = keys(var.regions)[count.index]
  plan             = "${var.packet_plan}"
  facilities       = [lookup(var.regions, keys(var.regions)[count.index])]
  operating_system = "ubuntu_19_04"
  billing_cycle    = "hourly"
  project_id       = var.packet_project_id
}
