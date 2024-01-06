
job "django-app" {
  datacenters = ["dc1"]
  type = "service"

  group "django-group" {
    network {
      port "django" {
        static = 8000
      }
    }

    task "django" {
      driver = "docker"

      config {
        image = "hello-django:v0.1"
        ports = ["django"]

        volumes = [
          # "local/myproject:/app",
          "global/docker.sock:/var/run/docker.sock:ro"
        ]

        labels = {
          "traefik.enable"                            = "true",
          "traefik.http.routers.django.rule"           = "Host(`localhost`)",
          "traefik.http.routers.django.entrypoints"    = "web-secure",
          "traefik.http.routers.django.tls"            = "true",
          "traefik.http.services.django.loadbalancer.server.port" = "8000"
        }
      }

      resources {
        cpu    = 5000
        memory = 2560
      }

    }
  }
}
