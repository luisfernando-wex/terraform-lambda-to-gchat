provider "aws" {
  version = "~> 2.0"
}

locals {
  function_name = "google-chat-lambda-function"
}

module "event_bridge_rule" {
  source = "terraform-aws-modules/event-bridge/aws"
  name   = "daily-trigger"

  schedule_expression = "cron(0 0 * * ? *)"

  targets = [
    {
      arn = aws_lambda_function.google_chat.arn
      id  = "google-chat-lambda-function-target"
    }
  ]
}

resource "aws_lambda_function" "google_chat" {
  filename      = "function.zip"
  function_name = local.function_name
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "index.handler"
  runtime       = "python3.10"
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}
