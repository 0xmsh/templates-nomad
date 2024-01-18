job "database" {
    datacenters = ["dc1"]
    type = "service"
    priority = 50

    group "cache" {

        network {
            port "db" {
                to = 6379
            }
        }

        task "redis" {

            driver = "docker"

            config {
                image          = "redis:7"
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
        count = 1
        
        task "mongo" {
            driver = "docker"
    
            config {
                image = "mongo:3.2"

                port_map {
                    db = 27017
                }
            }
    
            resources {
                
                network {
                    mbits = 10
                    port "db" {}
                }
            }
        }
    }

}
