terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }

  # Terraform Cloud configuration
  cloud {
    organization = "nawy"
    workspaces {
      name = "task"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_image" "app_image" {
  name         = "ahmedatiia11/node-hello:latest"
  keep_locally = false
}

resource "docker_container" "app_container" {
  name  = "app"
  image = docker_image.app_image.image_id
  env = [
    "NEW_RELIC_LICENSE_KEY=114beed378df1617048e4c8abdfdf59cFFFFNRAL",
    "NEW_RELIC_APP_NAME=node-hello-app",
    "NEW_RELIC_DISTRIBUTED_TRACING_ENABLED=true",
    "NEW_RELIC_LOG=stdout"
  ]

  ports {
    internal = 3000
    external = 3000
  }
}