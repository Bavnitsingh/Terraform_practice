provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "my-test-bucket" {
  bucket = "bsc-bucket-01"
  tags = {
    name = "test-bucket"
  }
}

resource "aws_instance" "ec2_eg" {
  ami = "ami-065d2b03fb493085a"
  instance_type = "t3.micro"
  key_name = "bsc-aws-prac-key"
  depends_on = [ aws_s3_bucket.my-test-bucket ]
}