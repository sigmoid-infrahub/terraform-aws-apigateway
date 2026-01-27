# Module: API Gateway

This module builds an AWS API Gateway v2 (HTTP/WebSocket API) with routing, integrations, authorizers, and stage management.

## Features
- Support for HTTP and WebSocket protocols
- Custom routes and integrations
- Authorizer configuration
- Stage and deployment management
- Custom domain name support
- VPC Link integration

## Usage
```hcl
module "apigateway" {
  source = "../../terraform-modules/terraform-aws-apigateway"

  name          = "my-api"
  protocol_type = "HTTP"
}
```

## Inputs
| Name | Type | Default | Description |
|------|------|---------|-------------|
| `name` | `string` | n/a | API Gateway name |
| `protocol_type` | `string` | n/a | Protocol type |
| `description` | `string` | `null` | API description |
| `api_version` | `string` | `null` | API version |
| `disable_execute_api_endpoint` | `bool` | `false` | Disable default execute API endpoint |
| `cors_configuration` | `any` | `null` | CORS configuration |
| `routes` | `any` | `[]` | Routes configuration |
| `integrations` | `any` | `[]` | Integrations configuration |
| `authorizers` | `any` | `[]` | Authorizers configuration |
| `stages` | `any` | `[]` | Stages configuration |
| `domain_name` | `string` | `null` | Custom domain name |
| `domain_name_certificate_arn` | `string` | `null` | Domain name certificate ARN |
| `vpc_link_id` | `string` | `null` | VPC link ID |
| `subnet_ids` | `list(string)` | `[]` | Subnet IDs |
| `security_group_ids` | `list(string)` | `[]` | Security group IDs |
| `access_log_settings` | `any` | `null` | Access log settings |
| `throttling_burst_limit` | `number` | `5000` | Throttling burst limit |
| `throttling_rate_limit` | `number` | `10000` | Throttling rate limit |
| `tags` | `map(string)` | `{}` | Tags to apply |

## Outputs
| Name | Description |
|------|-------------|
| `api_id` | API ID |
| `api_endpoint` | API endpoint |
| `module` | Full module outputs |

## Environment Variables
None

## Notes
- `protocol_type` must be either `HTTP` or `WEBSOCKET`.
- Custom domain names require a valid ACM certificate ARN.
