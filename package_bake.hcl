variable "VERSION" {
  default = ""
}

variable "REGISTRY_IMAGE" {
  default = ""
}

variable "CERTBOT_VERSION" {
  default = ""
}

target "default" {
  dockerfile = "Dockerfile"
  args = {
  }
  platforms = ["linux/amd64","linux/arm64","linux/arm/v7","linux/arm/v6"]
  tags = ["${REGISTRY_IMAGE}:${VERSION}"]
}