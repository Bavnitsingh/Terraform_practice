provider "aws" {
  region = "eu-north-1"
}

resource "aws_s3_bucket" "my_test_b" {
  bucket = "bscb"
  tags = {
    "name" = "test_bucket"
  }
}

resource "aws_s3_bucket_acl" "eg" {
  bucket = aws_s3_bucket.my_test_b.id
acl = "private"
}