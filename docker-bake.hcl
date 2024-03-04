variable "VERSION" {
  default = ""
}

variable "CERTBOT_VERSION" {
  default = ""
}

variable "REGISTRY_IMAGE" {
  default = ""
}

variable "REGISTRY_IMAGE_PUBLIC" {
  default = ""
}

target "default" {
  dockerfile = "Dockerfile"
  args = {
    VERSION = "${VERSION}"
    CERTBOT_VERSION = "${CERTBOT_VERSION}"
  }
  platforms = ["linux/amd64","linux/arm64","linux/arm/v7","linux/arm/v6"]
  tags = ["${REGISTRY_IMAGE}:${VERSION}","${REGISTRY_IMAGE_PUBLIC}:${VERSION}"]
}