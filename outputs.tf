output "api_id" {
  description = "API ID"
  value       = aws_apigatewayv2_api.this.id
}

output "api_endpoint" {
  description = "API endpoint"
  value       = aws_apigatewayv2_api.this.api_endpoint
}

output "module" {
  description = "Full module outputs"
  value = {
    api_id       = aws_apigatewayv2_api.this.id
    api_endpoint = aws_apigatewayv2_api.this.api_endpoint
  }
}
