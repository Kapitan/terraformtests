resource "docker_image" "nginx" {
  name         = "kapitanmf/nginx:1.19.timezonekiev2.7"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.latest
  name  = "tutorial"
  ports {
    internal = 80
    external = 8080
  }
}