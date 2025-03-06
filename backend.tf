terraform {
  cloud {
    organization = "leshawn-rice"

    workspaces {
      name = "devops-dev"
    }
  }
}
