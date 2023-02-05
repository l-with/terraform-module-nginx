resource "system_file" "FQDN_port_conf" {
  depends_on = [system_packages_apt.nginx]
  for_each = {
    for conf in var.nginx_confs : "${conf.port}" => conf
  }
  path    = "${var.nginx_configuration_home}/sites-available/${each.value.server_name}_https.conf"
  content = <<EOT
  # managed by terraform

server {
  server_tokens off;
{% if var.nginx_GNU %}
  add_header X-Clacks-Overhead "GNU Terry Pratchett";
{% endif %}

  ###########################################################################
  # start copy from/etc/nginx/sites-enabled/default managed by certbot
  ###########################################################################
  # listen [::]:${each.key} ssl ipv6only=on; # managed by Certbot
  listen [::]:${each.key} ssl; # managed by Certbot
  listen ${each.key} ssl; # managed by Certbot
  ssl_certificate /etc/letsencrypt/live/${each.value.server_name}/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/${each.value.server_name}/privkey.pem;
  # include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
  ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot
  ###########################################################################
  # end copy from/etc/nginx/sites-enabled/default managed by certbot
  ###########################################################################

  ###########################################################################
  # start copy from /etc/letsencrypt/options-ssl-nginx.conf
  ###########################################################################
  ssl_session_cache shared:le_nginx_SSL:10m;
  ssl_session_timeout 1440m;
  ssl_session_tickets off;

  ssl_protocols TLSv1.2 TLSv1.3;
  ssl_prefer_server_ciphers off;

  ssl_ciphers "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384";
  ###########################################################################
  # end copy from /etc/letsencrypt/options-ssl-nginx.conf
  ###########################################################################

  # ssl_prefer_server_ciphers on;
  add_header Strict-Transport-Security "max-age=31536000; preload" always;


    server_name ${each.value.server_name};

${each.value.conf_in_server_stanza}

}  
EOT
}

resource "system_link" "FQDN_port_conf" {
  depends_on = [system_packages_apt.nginx]
  for_each = {
    for conf in var.nginx_confs : "${conf.port}" => conf
  }
  path   = "${var.nginx_configuration_home}/sites-enabled/${each.value.server_name}_https.conf"
  target = system_file.FQDN_port_conf[each.key].path
}
