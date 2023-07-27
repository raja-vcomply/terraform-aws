# Create IAM role for EC2 instance
resource "aws_iam_role" "ec2_access_role" {
  name               = var.ec2_access_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach managed policies to the IAM role
resource "aws_iam_role_policy_attachment" "s3_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.ec2_access_role.name
}

resource "aws_iam_role_policy_attachment" "ecr_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
  role       = aws_iam_role.ec2_access_role.name
}

resource "aws_iam_role_policy_attachment" "ec2_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  role       = aws_iam_role.ec2_access_role.name
}



##########################################--IMPORTANT--##############################################
#  This will create a policy of type instance profile and attach the role to it
resource "aws_iam_instance_profile" "instance_profile" {
  name = var.ec2_access_role_name
  role = aws_iam_role.ec2_access_role.name
}
##########################################--IMPORTANT--##############################################