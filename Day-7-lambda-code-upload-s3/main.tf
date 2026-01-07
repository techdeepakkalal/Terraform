resource "aws_s3_bucket" "code_bucket" {
  bucket = "hyd-bns-code-bucket"
  
  }

  resource "aws_s3_object" "lambda_code" {
    bucket = aws_s3_bucket.code_bucket.id
    key    = "lambda_test.zip"
    source = "./lambda_test.zip"

    #change detection for S3 object by etag filemd5
    etag   = filemd5("./lambda_test.zip")
    
  }

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

# Lambda Function
resource "aws_lambda_function" "lambda_s3" {
    function_name = "lambda_s3_function"
    role          = aws_iam_role.lambda_exec_role.arn

    # Specify the handler, runtime, and S3 bucket details
    handler       = "lambda_test.lambda_handler"
    runtime       = "python3.14"
    s3_bucket     = aws_s3_bucket.code_bucket.id
    s3_key        = aws_s3_object.lambda_code.key

    #change detection for S3 uploaded code by source_code_hash
    source_code_hash = filemd5("./lambda_test.zip")

    # Configure timeout and memory size
    timeout       = 300
    memory_size   = 128
}