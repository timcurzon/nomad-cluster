job "nginxtest" {
  region = "global"
  datacenters = ["cluster-dev"]
  type = "service"

  update {
    max_parallel = 1
    health_check = "checks"
    min_healthy_time = "30s"
    healthy_deadline = "5m"
  }
  
  group "web" {
    count = 2
    
    task "static" {
      driver = "docker"
      config {
        image = "nginx:mainline-alpine"
        volumes = [
          "/services/assets/index.html:/usr/share/nginx/html/index.html"
        ]
      }

      service {
        address_mode = "driver"
        name = "nginxtest"
        port = 80

        tags = [
          "urlprefix-nginxtest.service.cluster/"
        ]

        check {
          address_mode = "driver"
          type = "http"
          path = "/"
          interval = "10s"
          timeout = "5s"
          port = 80
        }
      }

      env {
        ENV_TESTVAL = "nginx test env value 01"
        ENV_CHANGEME = "trigger job change 001"
      }

      resources {
        cpu = 100
        memory = 16

        network {
          mbits = 100
        }
      }
    }
  }
}