resource "aws_key_pair" "jenkins" {
  key_name   = var.key_name
  public_key = file("/home/ubuntu/.ssh/Jenkins-key.pub")
}
