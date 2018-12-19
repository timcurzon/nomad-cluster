job "fabio" {
  region = "global"
  datacenters = ["local-cluster"]
  type = "system"

  group "fabio" {

    update {
      max_parallel = 1
      stagger = "20s"
      health_check = "checks"
      min_healthy_time = "20s"
      healthy_deadline = "2m"
      auto_revert = true
    }

    task "fabio" {
      driver = "docker"
      config {
        image = "fabiolb/fabio:latest"
				port_map {
					http = 80
					#https = 443
					admin = 9998
				}
      }

      service {
        address_mode = "driver"
        name = "fabio"
				tags = ["${attr.unique.hostname}", "urlprefix-fabio.service.${meta.cluster-domain}/"]
				port = "admin"

        check {
          address_mode = "driver"
          type = "http"
          path = "/health"
          interval = "10s"
          timeout = "2s"
				  port = "admin"
        }
      }

			env {
				FABIO_registry_consul_addr = "front.this.node.${meta.cluster-domain}:8500"
				FABIO_registry_consul_register_enabled = "false"
				# FABIO_proxy_cs = "cs=service.${meta.cluster-domain};type=consul;cert=http://front.this.node.${meta.cluster-domain}:8500/v1/kv/fabio/cert"
				# FABIO_proxy_addr = ":80, :443;cs=service.${meta.cluster-domain}"
        FABIO_proxy_addr = ":80"
        ENV_CHANGEME = "trigger job change 003"
      }

      resources {
        cpu = 250
        memory = 96

        network {
					mbits = 100
					port "http" {
						static = 80
					}
					#port "https" {
					#	static = 443
					#}
					port "admin" {
						static = 9998
					}
        }
      }
    }
  }
}