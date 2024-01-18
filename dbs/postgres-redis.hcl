job "example" {
  datacenters = ["dc1"]

  group "cache" {

    network {
      port "db" {
        to = 6379
      }
    }

    task "redis" {
      driver = "docker"

      config {
        image          = "redis:7.0"
        ports          = ["db"]
        auth_soft_fail = true
      }

      resources {
        cpu    = 500
        memory = 256
      }
    }
  }

  group "database" {

    network {
      port "db" {
        to = 5432
      }
    }

    count = 1

    task "postgres" {
      driver = "docker"

      config {
        image = "postgres:15.1"
        ports = ["db"]
      }

      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}
