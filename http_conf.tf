resource "system_file" "sites_available_nginx_server_FQDN_http_conf" {
  depends_on = [system_packages_apt.nginx]
  count      = var.nginx_config ? 1 : 0
  path       = "${var.nginx_configuration_home}/sites-available/${var.nginx_server_FQDN}_http.conf"
  content    = <<EOT
  # managed by terraform
  server {
    server_tokens off;
    listen [::]:80;
    listen      80;
    server_name ${var.nginx_server_FQDN};
{% if var.nginx_GNU %}
    add_header X-Clacks-Overhead "GNU Terry Pratchett";
{% endif %}

    # Redirect all non-https requests
    rewrite ^ https://$host$request_uri? permanent;
  }
  EOT
}

resource "system_link" "sites_enabled_nginx_server_FQDN_http_conf" {
  count      = var.nginx_config ? 1 : 0
  path   = "${var.nginx_configuration_home}/sites-enabled/${var.nginx_server_FQDN}_http.conf"
  target = system_file.sites_available_nginx_server_FQDN_http_conf[0].path
}
