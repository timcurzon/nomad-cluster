job "vault" {
  region = "global"
  datacenters = ["local-cluster"]
  type = "service"

	constraint {
		operator = "distinct_hosts"
		value = "true"
	}

  group "vault" {
    count = 1

    update {
      max_parallel = 1
      stagger = "2m"
      health_check = "checks"
      min_healthy_time = "30s"
      healthy_deadline = "9m"
      auto_revert = true
    }

    task "vault" {
      driver = "docker"
      config {
        image = "vault:latest"
        command = "vault"
        args = [
          "server",
          "-config=/local/vault.hcl"
        ]
        port_map = {
          vault = 8200
        }
      }

      service {
        address_mode = "driver"
        name = "vault-nomad"

        check {
          address_mode = "driver"
          type = "http"
          path = "/v1/sys/health?standbyok"
          interval = "15s"
          timeout = "10s"
					port = 8200
        }
      }

      env {
        VAULT_ADDR = "http://127.0.0.1:8200"
        VAULT_REDIRECT_ADDR = "http://${NOMAD_IP_vault}:${NOMAD_HOST_PORT_vault}"
        ENV_CHANGEME = "trigger job change 001"
      }

      template {
        data = <<EOT
          backend "consul" {
            address = "front.this.node.{{ env "meta.cluster-domain" }}:8500"
            path = "/vault"
            service_tags = "urlprefix-vault.service.{{ env "meta.cluster-domain" }}/"
          }
          listener "tcp" {
            address = "0.0.0.0:8200"
            tls_disable = 1
            proxy_protocol_behavior = "use_always"
          }
          ui = true
          max_lease_ttl = "2232h"
          disable_mlock = true
        EOT
        destination = "/local/vault.hcl"
      }

      resources {
        cpu = 250
        memory = 100

        network {
          mbits = 10
          port "vault" {
            static = 8200
          }
        }
      }
    }
  }
}