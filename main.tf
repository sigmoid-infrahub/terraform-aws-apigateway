resource "aws_apigatewayv2_api" "this" {
  name          = var.name
  protocol_type = var.protocol_type
  description   = var.description
  version       = var.api_version

  disable_execute_api_endpoint = var.disable_execute_api_endpoint

  dynamic "cors_configuration" {
    for_each = var.cors_configuration == null ? [] : [var.cors_configuration]
    content {
      allow_credentials = lookup(cors_configuration.value, "allow_credentials", null)
      allow_headers     = lookup(cors_configuration.value, "allow_headers", null)
      allow_methods     = lookup(cors_configuration.value, "allow_methods", null)
      allow_origins     = lookup(cors_configuration.value, "allow_origins", null)
      expose_headers    = lookup(cors_configuration.value, "expose_headers", null)
      max_age           = lookup(cors_configuration.value, "max_age", null)
    }
  }

  tags = local.resolved_tags
}

resource "aws_apigatewayv2_integration" "this" {
  for_each = { for entry in var.integrations : entry.key => entry }

  api_id                 = aws_apigatewayv2_api.this.id
  integration_type       = each.value.integration_type
  integration_uri        = each.value.integration_uri
  integration_method     = lookup(each.value, "integration_http_method", null)
  payload_format_version = lookup(each.value, "payload_format_version", null)
  connection_type        = lookup(each.value, "connection_type", null)
  connection_id          = lookup(each.value, "connection_id", null)
  request_templates      = lookup(each.value, "request_templates", null)
}

resource "aws_apigatewayv2_authorizer" "this" {
  for_each = { for entry in var.authorizers : entry.key => entry }

  api_id          = aws_apigatewayv2_api.this.id
  authorizer_type = each.value.authorizer_type
  name            = each.value.name

  identity_sources = lookup(each.value, "identity_sources", null)
  authorizer_uri   = lookup(each.value, "authorizer_uri", null)

  dynamic "jwt_configuration" {
    for_each = lookup(each.value, "jwt_configuration", null) == null ? [] : [each.value.jwt_configuration]
    content {
      audience = lookup(jwt_configuration.value, "audience", null)
      issuer   = lookup(jwt_configuration.value, "issuer", null)
    }
  }
}

resource "aws_apigatewayv2_route" "this" {
  for_each = {
    for entry in var.routes : coalesce(entry.route_key, "${entry.method} ${entry.path}") => entry
  }

  api_id    = aws_apigatewayv2_api.this.id
  route_key = coalesce(each.value.route_key, "${each.value.method} ${each.value.path}")
  target    = "integrations/${aws_apigatewayv2_integration.this[each.value.integration_key].id}"

  authorization_type = lookup(each.value, "authorization_type", "NONE")
  authorizer_id      = lookup(each.value, "authorizer_key", null) == null ? null : aws_apigatewayv2_authorizer.this[each.value.authorizer_key].id
}

resource "aws_apigatewayv2_stage" "this" {
  for_each = { for entry in var.stages : entry.name => entry }

  api_id = aws_apigatewayv2_api.this.id
  name   = each.value.name

  auto_deploy = lookup(each.value, "auto_deploy", null)

  dynamic "access_log_settings" {
    for_each = var.access_log_settings == null ? [] : [var.access_log_settings]
    content {
      destination_arn = access_log_settings.value.destination_arn
      format          = access_log_settings.value.format
    }
  }

  dynamic "default_route_settings" {
    for_each = lookup(each.value, "method_settings", null) == null ? [] : [each.value.method_settings]
    content {
      throttling_burst_limit = lookup(default_route_settings.value[0], "throttling_burst_limit", null)
      throttling_rate_limit  = lookup(default_route_settings.value[0], "throttling_rate_limit", null)
      data_trace_enabled     = lookup(default_route_settings.value[0], "data_trace_enabled", null)
      logging_level          = lookup(default_route_settings.value[0], "logging_level", null)
    }
  }
}

resource "aws_apigatewayv2_domain_name" "this" {
  count = var.domain_name == null ? 0 : 1

  domain_name = var.domain_name

  domain_name_configuration {
    certificate_arn = var.domain_name_certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_apigatewayv2_api_mapping" "this" {
  count = var.domain_name == null ? 0 : 1

  api_id      = aws_apigatewayv2_api.this.id
  domain_name = aws_apigatewayv2_domain_name.this[0].id
  stage       = aws_apigatewayv2_stage.this[keys(aws_apigatewayv2_stage.this)[0]].name
}
