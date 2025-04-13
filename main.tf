terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }

  cloud {
    organization = "nawy"
    workspaces {
      name = "task"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"


  registry_auth {
    address  = "registry-1.docker.io"  
    username = var.dockerhub_username
    password = var.dockerhub_password
  }
}

# Build local image
resource "docker_image" "app_image" {
  name         = "registry-1.docker.io/ahmedatiia11/node-hello:latest"
  keep_locally = false
  
  build {
    context = "."
    dockerfile = "Dockerfile"
  }
}

# Push to Docker Hub
resource "docker_registry_image" "app_image" {
  name = docker_image.app_image.name
}



# Container deployment
resource "docker_container" "app_container" {
  name  = "app"
  image = docker_image.app_image.image_id
  env = [
    "SERVICE=elastic",
    "NEW_RELIC_LICENSE_KEY=114beed378df1617048e4c8abdfdf59cFFFFNRAL",
    "NEW_RELIC_APP_NAME=node-hello-app"
  ]

  ports {
    internal = 3000
    external = 3000
  }
}

# Variable definitions
variable "dockerhub_username" {
  type      = string
  sensitive = true
}

variable "dockerhub_password" {
  type      = string
  sensitive = true
}