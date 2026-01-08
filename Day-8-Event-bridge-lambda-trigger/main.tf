# Configure the AWS Provider
provider "aws" {
    region = "us-east-1"
  
}

# Create IAM Role for Lambda
resource "aws_iam_role" "lambda-role" {
    name = "lambda-execution-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                Service = "lambda.amazonaws.com"
            }
        }]
    })
  
}

# Attach AWSLambdaBasicExecutionRole policy to the IAM Role
resource "aws_iam_role_policy_attachment" "lambda-policy-attachment" {
    role       = aws_iam_role.lambda-role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Create Lambda Function
resource "aws_lambda_function" "lambda-trigger" {
    function_name = "event-bridge-lambda-trigger"
    role = aws_iam_role.lambda-role.arn
    runtime = "python3.14"
    handler = "lambda_test.lambda_handler"
    timeout = 150
    memory_size = 128


    filename = "lambda_test.zip"
    source_code_hash = filebase64sha256("lambda_test.zip")

}

# Create EventBridge Rule to trigger Lambda every 5 minutes
resource "aws_cloudwatch_event_rule" "lambda-schedule-rule" {
    name = "lambda-schedule-rule"
    description = "Triggers Lambda every 5 minutes"
    schedule_expression = "cron(*/5 * * * ? *)"

}

# Create EventBridge Target to link the rule to the Lambda function
resource "aws_cloudwatch_event_target" "lambda-target" {
    rule = aws_cloudwatch_event_rule.lambda-schedule-rule.name
    target_id = "lambda-target"
    arn = aws_lambda_function.lambda-trigger.arn
}

# Permission for EventBridge to invoke the Lambda function
resource "aws_lambda_permission" "event-bridge-permission" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.lambda-trigger.function_name
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.lambda-schedule-rule.arn
}
