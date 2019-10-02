resource "aws_dynamodb_table" "dynamo" {
  name           = "Rides"
  hash_key       = "RideId"
  read_capacity  = 5
  write_capacity = 5

  attribute {
    name = "RideId"
    type = "S"
  }
}
