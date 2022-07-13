# IAM for Fargate profile
resource "aws_iam_role" "hello-eks_fargate_profile_role" {
  name = "hello-eks-fargate-profile-example"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks-fargate-pods.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "hello-eks_fargate_profile_role-AmazonEKSFargatePodExecutionRolePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.hello-eks_fargate_profile_role.name
}

# Fargate profile to map pods to fargate hosts
# Does this create fargate compute? 
resource "aws_eks_fargate_profile" "hello-pod" {
  cluster_name           = aws_eks_cluster.aws_eks_cluster.name
  fargate_profile_name   = "hello-pod"
  pod_execution_role_arn = aws_iam_role.hello-eks_fargate_profile_role.arn
  subnet_ids = [
    "subnet-0ab8ce0c00a321478", #SquidTestPrivate1
    "subnet-0f3dbb9a59622dad5", #SquidTestPrivate2
  ]

  selector {
    namespace = "hello-pod"
  }
}