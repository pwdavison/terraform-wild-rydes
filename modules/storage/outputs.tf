output "dynamodb_table_arn" {
  value = "${aws_dynamodb_table.dynamo.arn}"
}
