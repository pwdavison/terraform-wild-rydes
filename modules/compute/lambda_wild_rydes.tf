data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/requestUnicorn.js"
  output_path = "${path.module}/requestUnicorn.zip"
}

resource "aws_lambda_function" "wild-rydes-lambda" {
  source_code_hash  = "${data.archive_file.lambda_zip.output_base64sha256}"
  filename         = "${data.archive_file.lambda_zip.output_path}"
  function_name    = "RequestUnicorn"
  role             = "${aws_iam_role.wild-rydes-role.arn}"
  runtime          = "nodejs8.10"
  handler          = "requestUnicorn.handler"
}

