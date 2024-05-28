# Qdrant Terraform Module

[![Terraform Registry URL](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)](https://registry.terraform.io/modules/iLert/qdrant/kubernetes/latest)

Terraform module to deploy Qdrant vector DB on kubernetes

## Usage

> Make sure you have Terraform installed

Create a `main.tf` file with the following content:

```terraform
module "qdrant" {
  source       = "iLert/qdrant/kubernetes"
  version      = "1.0.0"
  name         = "qdrant"
  namespace    = "default"
  storage_size = "10Gi"
  replica_count    = 3
  qdrant_version   = "latest"
}
```

Then run the following commands:

```sh
terraform init
terraform apply
```

## Modules

No modules.

## Inputs

| Name                                                                         | Description                             | Type     | Default   | Required |
| ---------------------------------------------------------------------------- | --------------------------------------- | -------- | --------- | :------: |
| <a name="input_name"></a> [name](#input\_name)                               | Kubernetes resources name               | `string` | `qdrant`  |    no    |
| <a name="input_namespace"></a> [namespace](#input\_namespace)                | Kubernetes namespace                    | `string` | `default` |    no    |
| <a name="input_memory_limit"></a> [memory\_limit](#input\_memory\_limit)     | Memory limit for the Qdrant instances   | `string` | `128Mi`   |    no    |
| <a name="input_storage_size"></a> [storage\_size](#input\_storage\_size)     | Storage size for the Qdrant instances   | `string` | `10Gi`    |    no    |
| <a name="input_replica_count"></a> [storage\_size](#input\_replica\_count)   | Replicas count for the Qdrant instances | `number` | `2`       |    no    |
| <a name="input_qdrant_version"></a> [storage\_size](#input\_qdrant\_version) | The Qdrant version                      | `string` | `latest`  |    no    |

## Outputs

| Name                                                                                          | Description                                                |
| --------------------------------------------------------------------------------------------- | ---------------------------------------------------------- |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name)                    | The name of the Qdrant service in the kubernetes namespace |
| <a name="output_api_key"></a> [api\_key](#output\_api\_key)                                   | The generated api key for the Qdrant API                   |
| <a name="output_read_only_api_key"></a> [read\_only\_api\_key](#output\_read\_only\_api\_key) | The generated read only api key for the Qdrant API         |
