provider "aws" {
    region = "eu-central-1"
}

# DynamoDB
resource "aws_dynamodb_table" "porsche_users" {
    name = "porsche-users"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "userId"

    attribute {
        name = "userId"
        type = "S"
    }
}

# IAM for Lambda
resource "aws_iam_role" "lambda_exec" {
    name = "porsche_lambda_role"
    
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    Service = "lambda.amazonaws.com"
                }
            }
        ]
    })
}

# IAM policy for Lambda
resource "aws_iam_policy" "lambda_policy" {
    name = "porsche_lambda_policy"
    description = "Allow Lambda to access DynamoDB"
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = [
                    "dynamodb:GetItem",
                    "dynamodb:PutItem",
                    "dynamodb:UpdateItem",
                    "dynamodb:DeleteItem",
                    "dynamodb:Query",
                    "logs:createLogGroup",
                    "logs:createLogStream",
                    "logs:putLogEvents"
                ]
                Effect = "Allow"
                Resource = [
                    aws_dynamodb_table.porsche_users.arn,
                    "${aws_dynamodb_table.porsche_users.arn}/*"
                ]
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# Lambda
resource "aws_lambda_function" "porsche_lambda" {
    filename = "lambda.zip"
    function_name = "porsche_lambda"
    role = aws_iam_role.lambda_exec.arn
    handler = "lambda.handler"
    runtime = "python3.9"

    environment {
        variables = {
            DYNAMODB_TABLE = aws_dynamodb_table.porsche_users.name
            DALLE_API_KEY = var.dalle_api_key
        }
    }
}

# API Gateway
resource "aws_apigatewayv2_api" "main" {
    name = "porsche_api"
    protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "lambda" {
    api_id = aws_apigatewayv2_api.main.id
    integration_type = "AWS_PROXY"

    integration_method = "POST"
    integration_uri = aws_lambda_function.porsche_lambda.invoke_arn
}

resource "aws_apigatewayv2_route" "api_routes" {
    api_id = aws_apigatewayv2_api.main.id
    route_key = "ANY /{proxy+}"
    target = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.main.id
  name        = "$default"
  auto_deploy = true
}