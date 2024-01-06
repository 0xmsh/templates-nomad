job "example" {
  datacenters = ["dc1"]

  group "example-group" {
    count = 1

    task "example-task" {
      driver = "exec"

      config {
        command = "echo"
        args = ["Hello, Nomad!"]
      }
    }
  }
}