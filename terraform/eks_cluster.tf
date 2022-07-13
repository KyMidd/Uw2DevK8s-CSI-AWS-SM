# Creates the EKS main cluster
# Note: No compute is created automatically, so all pods fail to schedule, including core DNS
resource "aws_eks_cluster" "aws_eks_cluster" {
  name     = "Uw2DevKylerTesting"
  role_arn = "arn:aws:iam::072100331905:role/EksClusterRole"
  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  vpc_config {
    subnet_ids = [
      "subnet-0ab8ce0c00a321478", #SquidTestPrivate1
      "subnet-0f3dbb9a59622dad5", #SquidTestPrivate2
      #"subnet-0325dfeb96e75b9df", #SquidTestPublic1
      #"subnet-0dad2b207fd02239a", #SquidTestPublic2
    ]
  }
  timeouts {
    delete = "30m"
  }
}
