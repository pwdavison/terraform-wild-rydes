resource "aws_cognito_user_pool" "cognito_user_pool" {
  name                     = "wild-ryde-user-pool"
  auto_verified_attributes = ["email"]
}

resource "aws_cognito_user_pool_client" "client" {
  name            = "wild-ryde-user-pool-client"
  user_pool_id    = "${aws_cognito_user_pool.cognito_user_pool.id}"
  generate_secret = "false"
}
