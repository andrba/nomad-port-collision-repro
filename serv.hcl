job "serv" {
  datacenters = ["dc1"]

  group "group" {
    count = 1

    update {
      canary            = 1
      max_parallel      = 1
      healthy_deadline  = "1m"
      progress_deadline = "2m"
      auto_revert       = true
      auto_promote      = true
    }

    task "task" {
      driver = "docker"
      config {
        network_mode = "host"
        image = "sleepy:1.0.0"
        command = "/go/bin/sleepy"
        args = ["-shutdown-delay", "0"]
      }
    }
  }
}
