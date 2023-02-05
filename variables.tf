variable "nginx_install" {
  description = "if nginx should be installed and enabled"
  type        = bool
  default     = true
}

variable "nginx_config" {
  description = "if the standard nginx configration should be done"
  type        = bool
  default     = true
}

variable "nginx_GNU" {
  description = "if the [GNU Terry Pratchett](http://www.gnuterrypratchett.com) header should be inserted"
  type        = bool
  default     = true
}

variable "nginx_configuration_home" {
  description = "the configration home of nginx"
  type        = string
  default     = "/etc/nginx"
}

variable "nginx_server_FQDN" {
  description = "the FQDN of the server for nginx_server_name and Let's Encrypt certificates"
  type        = string
}

variable "nginx_https_map" {
  description = "the map stanza configuration for nginx https configuration"
  type        = string
  default     = ""
}

variable "nginx_vouch_FQDN" {
  description = "the FQDN of vouch-proxy"
  type        = string
  default     = ""
}

variable "nginx_vouch_port" {
  description = "the port of vouch-proxy"
  type        = number
  default     = 9090
}

variable "nginx_https_conf" {
  description = "the nginx https configuration after `server_name` "
  type        = string
  default     = ""
}

variable "nginx_confs" {
  description = "the extra configurations for nginx as list of object"
  type = list(object({
    port                  = number
    server_name           = string
    conf_in_server_stanza = string
  }))
  default = []
}
