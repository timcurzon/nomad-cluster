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
      }

      service {
        address_mode = "driver"
        name = "fabio"
        port = 80

        check {
          address_mode = "driver"
          type = "http"
          path = "/"
          interval = "30s"
          timeout = "10s"
          port = 80
        }
      }

      env {
        "ENV_TESTVAL" = "nginx test env value 01"
        "ENV_CHANGEME" = "trigger job change 001"
      }

      resources {
        cpu = 1000
        memory = 64

        network {
          mbits = 100
        }
      }
    }
  }
}