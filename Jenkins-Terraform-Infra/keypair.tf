resource "aws_key_pair" "jenkins" {
  key_name   = "Jenkins-key"
  public_key = file("~/.ssh/Jenkins-key.pub")
}
