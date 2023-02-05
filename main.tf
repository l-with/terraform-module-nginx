resource "system_packages_apt" "nginx" {
  count = var.nginx_install ? 1 : 0
  package {
    name = "nginx"
  }
}

data "system_command" "rm_sites_enabled_default" {
  depends_on = [system_packages_apt.nginx]
  count      = var.nginx_config ? 1 : 0
  command    = "rm ${var.nginx_configuration_home}/sites-enabled/default"
}

resource "system_service_systemd" "nginx" {
  depends_on = [
    system_link.sites_enabled_nginx_server_FQDN_http_conf,
    system_link.sites_enabled_nginx_server_FQDN_https_conf,
    system_file.conf_d_ssl_ehcd_curve_conf,
    system_link.FQDN_port_conf
  ]
  count  = var.nginx_install ? 1 : 0
  name   = "nginx"
  status = "started"
}

