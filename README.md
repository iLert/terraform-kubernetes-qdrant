# Qdrant Terraform Module

[![Terraform Registry URL](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)](https://registry.terraform.io/modules/ilert/qdrant/kubernetes/latest)

Terraform module to deploy Qdrant vector DB on kubernetes

## Usage

> Make sure you have Terraform installed

Create a `main.tf` file with the following content:

```terraform
module "qdrant" {
  source       = "ilert/qdrant/kubernetes"
  version      = "0.1.0"
  name         = "qdrant"
  namespace    = "default"
  storage_size = "10Gi"
}
```

Then run the following commands:

```sh
terraform init
terraform apply
```

