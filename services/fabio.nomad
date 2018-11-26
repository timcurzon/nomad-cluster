job "fabio" {
  region = "global"
  datacenters = ["cluster-dev"]
  type = "system"

  update {
    max_parallel = 1
	  stagger = "30s"
    health_check = "checks"
    min_healthy_time = "60s"
    healthy_deadline = "5m"
		auto_revert = true
  }
  
  group "fabio" {

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
				tags = ["${attr.unique.hostname}", "urlprefix-fabio.service.cluster/"]
				port = "admin"

        check {
          address_mode = "driver"
          type = "http"
          path = "/health"
          interval = "30s"
          timeout = "10s"
				  port = "admin"
        }
      }

			env {
				FABIO_registry_consul_addr = "front.this.node.cluster:8500"
				FABIO_registry_consul_register_enabled = "true"
				# FABIO_proxy_cs = "cs=service.cluster;type=consul;cert=http://front.this.node.cluster:8500/v1/kv/fabio/cert"
				# FABIO_proxy_addr = ":80, :443;cs=service.cluster"
        FABIO_proxy_addr = ":80"
        ENV_CHANGEME = "trigger job change 001"
      }

      resources {
        cpu = 1000
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