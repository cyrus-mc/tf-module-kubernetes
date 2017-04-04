/*
  Create user data for each master/etcd instance
*/
data "template_file" "cloud-config" {
  count    =  "${var.servers}"

  template = "${file("${path.module}/cloud-config.yml")}"

  vars {
    HOSTNAME         = "etcd-${count.index + 1}"

    /* the SRV domain for etcd bootstrapping */
    SRV-DOMAIN       = "${var.name}.${var.internal-tld}"

    CLUSTER_NAME     = "${var.name}"

    K8S-VERSION      = "v1.5.4_coreos.0"

    AWS_REGION       = "${var.region}"

    /* Point at the etcd ELB */
    ETCD_ELB         = "etcd.${var.name}.${var.internal-tld}"

    ETCD_TOKEN       = "etcd-cluster-${var.name}"

    ADVERTISE_IP     = "${element(null_resource.etcd_instance_ip.*.triggers.private_ip, count.index)}"

    NETWORK_PLUGIN   = "cni"

    POD_NETWORK      = "${var.pod_network}"

    SERVICE_IP_RANGE = "${var.service_ip_range}"
    DNS_SERVICE_IP   = "${cidrhost(var.service_ip_range, 10)}"
  }
}
