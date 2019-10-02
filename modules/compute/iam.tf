resource "aws_iam_role" "wild-rydes-role" {
  name               = "${var.environment}-wild-rydes-role"
  assume_role_policy = "${data.aws_iam_policy_document.wild_rydes_assume_role_policy_document.json}"
  path               = "/"
}

resource "aws_iam_role_policy_attachment" "wild_rydes_policy_attachment" {
  role       = "${aws_iam_role.wild-rydes-role.id}"
  policy_arn = "${aws_iam_policy.wild_rydes_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "wild-rydes-lambda-basic" {
  role       = "${aws_iam_role.wild-rydes-role.id}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "wild_rydes_policy" {
  name   = "wild_rydes_${var.environment}"
  path   = "/"
  policy = "${data.aws_iam_policy_document.wild_rydes_policy_document.json}"
}

data "aws_iam_policy_document" "wild_rydes_policy_document" {
  statement {
    effect    = "Allow"
    actions   = ["dynamodb:PutItem"]
    resources = ["${var.dynamo_arn}"]
  }
}

resource "aws_lambda_permission" "wild-rydes-lambda-permission" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.wild-rydes-lambda.function_name}"
  principal     = "apigateway.amazonaws.com"

  source_arn = "${var.api_gateway_arn}/*/POST/ride"
}

data "aws_iam_policy_document" "wild_rydes_assume_role_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}