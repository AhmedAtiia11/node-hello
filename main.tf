terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
  registry_auth {
    address  = "registry-1.docker.io"  
    username = var.dockerhub_username
    password = var.dockerhub_password
  }
}

variable "dockerhub_username" {
  type = string
}

variable "dockerhub_password" {
  type      = string
  sensitive = true
}

resource "docker_image" "app_image" {
  name = "registry-1.docker.io/ahmedatiia11/node-hello:latest"
  build {
    context    = "."
    dockerfile = "Dockerfile"
    tag        = ["registry-1.docker.io/ahmedatiia11/node-hello:latest"]
  }
}

resource "docker_registry_image" "app_image" {
  name          = docker_image.app_image.name
  keep_remotely = true  # Keep image in registry even after destroy
}

resource "docker_container" "app_container" {
  name         = "app"
  image        = docker_image.app_image.image_id

  
  ports {
    internal = 3000
    external = 3000
  }

  restart = "unless-stopped"  # Add restart policy to handle crashes
}

