# terraform-module-ningx

Terraform module which installs and configures ningx.

This is a terraform replacement for [Ansible Role Nginx](https://github.com/l-with/ansible-role-nginx).

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15 |
| <a name="requirement_system"></a> [system](#requirement\_system) | >= 0.3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_system"></a> [system](#provider\_system) | >= 0.3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [system_file.FQDN_port_conf](https://registry.terraform.io/providers/neuspaces/system/latest/docs/resources/file) | resource |
| [system_file.conf_d_ssl_ehcd_curve_conf](https://registry.terraform.io/providers/neuspaces/system/latest/docs/resources/file) | resource |
| [system_file.sites_available_nginx_server_FQDN_http_conf](https://registry.terraform.io/providers/neuspaces/system/latest/docs/resources/file) | resource |
| [system_file.sites_available_nginx_server_FQDN_https_conf](https://registry.terraform.io/providers/neuspaces/system/latest/docs/resources/file) | resource |
| [system_link.FQDN_port_conf](https://registry.terraform.io/providers/neuspaces/system/latest/docs/resources/link) | resource |
| [system_link.sites_enabled_nginx_server_FQDN_http_conf](https://registry.terraform.io/providers/neuspaces/system/latest/docs/resources/link) | resource |
| [system_link.sites_enabled_nginx_server_FQDN_https_conf](https://registry.terraform.io/providers/neuspaces/system/latest/docs/resources/link) | resource |
| [system_packages_apt.nginx](https://registry.terraform.io/providers/neuspaces/system/latest/docs/resources/packages_apt) | resource |
| [system_service_systemd.nginx](https://registry.terraform.io/providers/neuspaces/system/latest/docs/resources/service_systemd) | resource |
| [system_command.rm_sites_enabled_default](https://registry.terraform.io/providers/neuspaces/system/latest/docs/data-sources/command) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_nginx_GNU"></a> [nginx\_GNU](#input\_nginx\_GNU) | if the [GNU Terry Pratchett](http://www.gnuterrypratchett.com) header should be inserted | `bool` | `true` | no |
| <a name="input_nginx_config"></a> [nginx\_config](#input\_nginx\_config) | if the standard nginx configration should be done | `bool` | `true` | no |
| <a name="input_nginx_configuration_home"></a> [nginx\_configuration\_home](#input\_nginx\_configuration\_home) | the configration home of nginx | `string` | `"/etc/nginx"` | no |
| <a name="input_nginx_confs"></a> [nginx\_confs](#input\_nginx\_confs) | the extra configurations for nginx as list of object | <pre>list(object({<br>    port                  = number<br>    server_name           = string<br>    conf_in_server_stanza = string<br>  }))</pre> | `[]` | no |
| <a name="input_nginx_https_conf"></a> [nginx\_https\_conf](#input\_nginx\_https\_conf) | the nginx https configuration after `server_name` | `string` | `""` | no |
| <a name="input_nginx_https_map"></a> [nginx\_https\_map](#input\_nginx\_https\_map) | the map stanza configuration for nginx https configuration | `string` | `""` | no |
| <a name="input_nginx_install"></a> [nginx\_install](#input\_nginx\_install) | if nginx should be installed and enabled | `bool` | `true` | no |
| <a name="input_nginx_server_FQDN"></a> [nginx\_server\_FQDN](#input\_nginx\_server\_FQDN) | the FQDN of the server for nginx\_server\_name and Let's Encrypt certificates | `string` | n/a | yes |
| <a name="input_nginx_vouch_FQDN"></a> [nginx\_vouch\_FQDN](#input\_nginx\_vouch\_FQDN) | the FQDN of vouch-proxy | `string` | `""` | no |
| <a name="input_nginx_vouch_port"></a> [nginx\_vouch\_port](#input\_nginx\_vouch\_port) | the port of vouch-proxy | `number` | `9090` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
