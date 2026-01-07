# IAM Policy for Lambda Execution Role
resource "aws_iam_policy" "lambda_exec_policy" {
    name        = "lambda_exec_policy"
    description = "IAM policy for Lambda execution role"
    policy      = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = [
                    "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents"
                ]
                Effect   = "Allow"
                Resource = "arn:aws:logs:*:*:*"
            }
        ]
    })
  
}

# IAM Role for Lambda Execution
resource "aws_iam_role" "lambda_exec_role" {
    name               = "lambda_exec_role"
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

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "attach_lambda_exec_policy" {
    role       = aws_iam_role.lambda_exec_role.name
    policy_arn = aws_iam_policy.lambda_exec_policy.arn
}

# Create Lambda Function
resource "aws_lambda_function" "my_lambda" {
    function_name = "my_lambda_function"
    role          = aws_iam_role.lambda_exec_role.arn

    # Specify the handler, runtime, and the local zip file
    handler       = "function_test.lambda_handler"
    runtime       = "python3.14"
    filename      = "function_test.zip"

    #For local file upload, we need to provide source_code_hash
    source_code_hash = filebase64sha256("function_test.zip")

    # Configure timeout and memory size
    timeout = 300
    memory_size = 128
  
}