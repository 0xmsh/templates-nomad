#To Configure vault
# vault secrets enable database
# vault write database/config/postgresql  plugin_name=postgresql-database-plugin   connection_url="postgresql://{{username}}:{{password}}@postgres.service.consul:5432/postgres?sslmode=disable"   allowed_roles="*"     username="root"     password="rootpassword"
# vault write database/roles/readonly db_name=postgresql     creation_statements=@readonly.sql     default_ttl=1h max_ttl=24h

job "postgres" {
  # datacenters = ["eu-west-2","eu-west-1","ukwest","sa-east-1","ap-northeast-1","dc1"]
  datacenters = ["dc1"]
  type = "service"

  group "postgres" {
    count = 1

    network {
      mbits = 10
      port "postgres" {
        static = 5432
      }
    }

    task "postgres" {
      driver = "docker"
      config {
        image = "postgres"
        network_mode = "host"
        ports=["postgres"]

      }
      env {
          POSTGRES_USER="root"
          POSTGRES_PASSWORD="rootpassword"
      }

      logs {
        max_files     = 5
        max_file_size = 15
      }

      resources {
        cpu = 1000
        memory = 1024
      }
      service {
        name = "postgres"
        tags = ["postgres for vault"]
        port = "postgres"

        check {
          name     = "alive"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

  }

  update {
    max_parallel = 1
    min_healthy_time = "5s"
    healthy_deadline = "3m"
    auto_revert = false
    canary = 0
  }
}
