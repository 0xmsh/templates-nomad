job "traefik" {
  datacenters = ["dc1"]
  type = "system"

  group "traefik" {
    network {
      port "web" {
        to = 80
      }
      port "web-secure" {
        to = 443
      }
      port "dashboard" {
        to = 8080
      }
    }

    task "traefik" {
      driver = "docker"

      config {
        image = "traefik:v2.9"

        volumes = [
          "local/letsencrypt:/letsencrypt",
          "global/docker.sock:/var/run/docker.sock:ro"
        ]

        args = [
          "--api.insecure=true",
          "--providers.docker=true",
          "--providers.docker.exposedbydefault=false",
          "--providers.docker.endpoint=unix:///var/run/docker.sock",
          "--entrypoints.web.address=:80",
          "--entrypoints.web-secure.address=:443",
          "--certificatesresolvers.myresolver.acme.tlschallenge=true",
          "--certificatesresolvers.myresolver.acme.email=your@email.com",
          "--certificatesresolvers.myresolver.acme.storage=/letsencrypt/acme.json"
        ]

        ports = ["web", "web-secure", "dashboard"]
      }

      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}
