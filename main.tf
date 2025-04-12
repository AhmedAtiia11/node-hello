terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"  # Correct provider source
      version = "3.0.2"             # Check for the latest version if needed
    }
  }
}

provider "docker" {}

resource "docker_image" "app_image" {
  name         = "ahmedatiia11/node-hello:latest"
}

resource "docker_container" "app_container" {
  name  = "app"
  image = docker_image.app_image.image_id
  ports {
    internal = 3000
    external = 3000
  }
}