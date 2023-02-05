resource "system_file" "conf_d_ssl_ehcd_curve_conf" {
  depends_on = [system_packages_apt.nginx]
  count      = var.nginx_config ? 1 : 0
  path       = "${var.nginx_configuration_home}/conf.d/ssl_ehcd_curve.conf"
  content    = "ssl_ecdh_curve secp384r1;"
}

locals {
  nginx_port = 443
}

resource "system_file" "sites_available_nginx_server_FQDN_https_conf" {
  depends_on = [system_packages_apt.nginx]
  count      = var.nginx_config ? 1 : 0
  path       = "${var.nginx_configuration_home}/sites-available/${var.nginx_server_FQDN}_https.conf"
  content    = <<EOT
# managed by terraform
%{ if var.nginx_https_map == "" }
${var.nginx_https_map}
%{ endif }

server {
  server_tokens off;
%{ if var.nginx_GNU }
  add_header X-Clacks-Overhead "GNU Terry Pratchett";
%{ endif }

  ###########################################################################
  # start copy from/etc/nginx/sites-enabled/default managed by certbot
  ###########################################################################
  # listen [::]:${local.nginx_port} ssl ipv6only=on; # managed by Certbot
  listen [::]:${local.nginx_port} ssl; # managed by Certbot
  listen ${local.nginx_port} ssl; # managed by Certbot
  ssl_certificate /etc/letsencrypt/live/${var.nginx_server_FQDN}/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/${var.nginx_server_FQDN}/privkey.pem;
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

%{ if var.nginx_vouch_FQDN != "" }
  ###########################################################################
  # start copy from https://github.com/vouch/vouch-proxy
  ###########################################################################

  # send all requests to the `/validate` endpoint for authorization
  auth_request /validate;

  location = /validate {
    # forward the /validate request to Vouch Proxy
    proxy_pass http://127.0.0.1:${var.nginx_vouch_port}/validate;

    # be sure to pass the original host header
    proxy_set_header Host $http_host;

    # Vouch Proxy only acts on the request headers
    proxy_pass_request_body off;
    proxy_set_header Content-Length "";

    # optionally add X-Vouch-User as returned by Vouch Proxy along with the request
    auth_request_set $auth_resp_x_vouch_user $upstream_http_x_vouch_user;

    # optionally add X-Vouch-IdP-Claims-* custom claims you are tracking
    #    auth_request_set $auth_resp_x_vouch_idp_claims_groups $upstream_http_x_vouch_idp_claims_groups;
    #    auth_request_set $auth_resp_x_vouch_idp_claims_given_name $upstream_http_x_vouch_idp_claims_given_name;
    # optinally add X-Vouch-IdP-AccessToken or X-Vouch-IdP-IdToken
    #    auth_request_set $auth_resp_x_vouch_idp_accesstoken $upstream_http_x_vouch_idp_accesstoken;
    #    auth_request_set $auth_resp_x_vouch_idp_idtoken $upstream_http_x_vouch_idp_idtoken;

    # these return values are used by the @error401 call
    auth_request_set $auth_resp_jwt $upstream_http_x_vouch_jwt;
    auth_request_set $auth_resp_err $upstream_http_x_vouch_err;
    auth_request_set $auth_resp_failcount $upstream_http_x_vouch_failcount;

    # Vouch Proxy can run behind the same Nginx reverse proxy
    # may need to comply to "upstream" server naming
    # proxy_pass http://${var.nginx_vouch_FQDN}/validate;
    # proxy_set_header Host $http_host;
  }

  # if validate returns `401 not authorized` then forward the request to the error401block
  error_page 401 = @error401;

  location @error401 {
    # redirect to Vouch Proxy for login
    return 302 https://${var.nginx_vouch_FQDN}/login?url=$scheme://$http_host$request_uri&vouch-failcount=$auth_resp_failcount&X-Vouch-Token=$auth_resp_jwt&error=$auth_resp_err;
    # you usually *want* to redirect to Vouch running behind the same Nginx config proteced by https
    # but to get started you can just forward the end user to the port that vouch is running on
    # return 302 http://${var.nginx_vouch_FQDN}:9090/login?url=$scheme://$http_host$request_uri&vouch-failcount=$auth_resp_failcount&X-Vouch-Token=$auth_resp_jwt&error=$auth_resp_err;
  }
  ###########################################################################
  # end copy from https://github.com/vouch/vouch-proxy
  ###########################################################################
%{ endif }

  server_name ${var.nginx_server_FQDN};

${var.nginx_https_conf}

}  
EOT
}

resource "system_link" "sites_enabled_nginx_server_FQDN_https_conf" {
  count  = var.nginx_config ? 1 : 0
  path   = "${var.nginx_configuration_home}/sites-enabled/${var.nginx_server_FQDN}_https.conf"
  target = system_file.sites_available_nginx_server_FQDN_https_conf[0].path
}
