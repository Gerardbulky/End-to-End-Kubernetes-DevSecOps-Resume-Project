resource "aws_key_pair" "jenkins" {
  key_name   = "Jenkins-key"
  public_key = file("/home/ubuntu/.ssh/Jenkins-key.pub")
}
