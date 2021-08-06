terraform {
  backend "remote" {
    organization = "alsofer"

    workspaces {
      name = "comentarios-api-infra"
    }
  }
}