resource "aws_s3_bucket" "wild_rydes" {
  bucket        = "${var.account_alias}-${var.environment}-${var.region}-wild-rydes"
  force_destroy = true
  website {
    index_document = "index.html"
  }

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow", 
            "Principal": "*", 
            "Action": "s3:GetObject", 
            "Resource": "arn:aws:s3:::${var.account_alias}-${var.environment}-${var.region}-wild-rydes/*" 
        } 
    ] 
}
EOF
}

data "template_file" "config" {
  template = "${file("${path.module}/config.js.tpl")}"
  vars = {
    userPoolId       = "${var.cognito_user_pool_id}"
    userPoolClientId = "${var.cognito_user_pool_client_id}"
    api_invoke_Url   = "${var.api_invoke_Url}"
    region           = var.region
  }

}

resource "null_resource" "upload_to_s3" {
  provisioner "local-exec" {
    command = "aws s3 sync s3://wildrydes-us-east-1/WebApplication/1_StaticWebHosting/website s3://${var.account_alias}-${var.environment}-${var.region}-wild-rydes --region ${var.region}"
  }
}
resource "aws_s3_bucket_object" "config" {
  bucket  = "${aws_s3_bucket.wild_rydes.id}"
  key     = "js/config.js"
  content = "${data.template_file.config.rendered}"
}
