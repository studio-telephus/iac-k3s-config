locals {
  cluster_domain = "cluster.local"
  cluster_san    = "k3s.${var.env}.acme.corp"
//  workload_ip = {
//    dev = "10.20.0.32"
//    tst = "10.30.0.32"
//  }
}
