module "worker" {
  source                    = "github.com/nubisproject/nubis-terraform//worker?ref=v1.4.0"
  region                    = "${var.region}"
  environment               = "${var.environment}"
  account                   = "${var.account}"
  service_name              = "${var.service_name}"
  purpose                   = "webserver"
  ami                       = "${var.ami}"
  elb                       = "${module.load_balancer.name}"
  wait_for_capacity_timeout = "60m"
  health_check_grace_period = 1200
  min_instances             = 2
  nubis_sudo_groups         = "team_webops,nubis_global_admins"
}

module "load_balancer" {
  source       = "github.com/nubisproject/nubis-terraform//load_balancer?ref=v1.4.0"
  region       = "${var.region}"
  environment  = "${var.environment}"
  account      = "${var.account}"
  service_name = "${var.service_name}"

  health_check_target = "HTTP:80/planet.css"
}

module "dns" {
  source       = "github.com/nubisproject/nubis-terraform//dns?ref=v1.4.0"
  region       = "${var.region}"
  environment  = "${var.environment}"
  account      = "${var.account}"
  service_name = "${var.service_name}"
  target       = "${module.load_balancer.address}"
}
