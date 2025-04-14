terraform {
  required_version = ">= 1.0" 
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

# Variable definitions
variable "docker_image_name" {
  type        = string
  description = "Name of the Docker image"
  default     = "registry-1.docker.io/ahmedatiia11/node-hello:latest"
}

variable "dockerhub_username" {
  type        = string
  sensitive   = true
  description = "Docker Hub username for authentication and pushing images"
}

variable "dockerhub_password" {
  type        = string
  sensitive   = true
  description = "Docker Hub password for authentication and pushing images"
}

variable "new_relic_license_key" {
  type        = string
  sensitive   = true
  description = "New Relic license key for application monitoring and observability"
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
  name         = var.docker_image_name
  keep_locally = false
  
  build {
    context = "."
    dockerfile = "Dockerfile"
  }
}

# Push to Docker Hub
resource "docker_registry_image" "app_image" {
  name = var.docker_image_name
}



# Container deployment
resource "docker_container" "app_container" {
  name  = "app"
  image = docker_image.app_image.image_id
  env = [
    "SERVICE=elastic",
    "NEW_RELIC_APP_NAME=node-hello-app",
    "NEW_RELIC_LICENSE_KEY=${var.new_relic_license_key}"
  ]

  ports {
    internal = 3000
    external = 3000
  }
}

