job "nginxtest" {
  region = "global"
  datacenters = ["cluster-dev"]
  type = "service"
  
  group "web" {
    count = 1
    
    task "static" {
      driver = "docker"
      config {
        image = "nginx:mainline-alpine"
        volumes = [
          "/services/assets/index.html:/usr/share/nginx/html/index.html"
        ]
        port_map = {
          http = 80
        }
      }

      service {
        address_mode = "driver"
        name = "nginxtest"
        port = "http"

        check {
          type = "http"
          path = "/"
          interval = "30s"
          timeout = "10s"
          port = "http"
        }
      }

      env {
        "ENV_TESTVAL" = "nginx test env value 01"
        "ENV_CHANGEME" = "trigger job change 001"
      }

      resources {
        cpu = 500
        memory = 32

        network {
          mbits = 100
          port "http" {}
        }
      }
    }
  }
}