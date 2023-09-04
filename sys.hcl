job "sys" {
  datacenters = ["dc1"]
  type = "system"

  group "sleepy" {
    network {
      port "http" {
        static = 3002
      }
    }

    task "sleepy" {
      driver = "docker"

      config {
        network_mode = "host"
        image = "sleepy:1.0.0"
        command = "/go/bin/sleepy"
        args = [
          "-port",
          "${NOMAD_PORT_http}",
          "-shutdown-delay",
          "30",
        ]
      }

      env {
        ITERATION = 0
      }
    }
  }
}
