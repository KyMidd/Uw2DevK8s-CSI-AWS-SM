# Auth for cluster
data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.aws_eks_cluster.id
}

# IAM for Fargate profile
resource "aws_iam_role" "kube-system-eks_fargate_profile_role" {
  name = "kube-system-eks-fargate-profile-example"

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

resource "aws_iam_role_policy_attachment" "kube-system-eks_fargate_profile_role-AmazonEKSFargatePodExecutionRolePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.kube-system-eks_fargate_profile_role.name
}

# Fargate profile to map pods to fargate hosts
# Does this create fargate compute? 
resource "aws_eks_fargate_profile" "kube-system-pod" {
  cluster_name           = aws_eks_cluster.aws_eks_cluster.name
  fargate_profile_name   = "kube-system-pod"
  pod_execution_role_arn = aws_iam_role.kube-system-eks_fargate_profile_role.arn
  subnet_ids = [
    "subnet-0ab8ce0c00a321478", #SquidTestPrivate1
    "subnet-0f3dbb9a59622dad5", #SquidTestPrivate2
  ]

  selector {
    namespace = "kube-system"
    labels = {
      k8s-app = "kube-dns"
    }
  }
}

module "template_files" {
  source = "hashicorp/dir/template"

  base_dir             = "."
  template_file_suffix = ".yml"
  template_vars = {
    aws_eks_cluster_ca_cert  = aws_eks_cluster.aws_eks_cluster.certificate_authority[0].data
    aws_eks_cluster_endpoint = aws_eks_cluster.aws_eks_cluster.endpoint
    aws_eks_cluster_token    = data.aws_eks_cluster_auth.cluster.token
  }
}

/*
# Generate kubeconfig template file to be used by local-exec commands
data "cloudinit_config" "kubeconfig" {
  template = <<EOF
apiVersion: v1
kind: Config
current-context: terraform
clusters:
- name: cluster
  cluster:
    certificate-authority-data: ${data.aws_eks_cluster.aws_eks_cluster.certificate_authority.0.data}
    server: ${data.aws_eks_cluster.aws_eks_cluster.endpoint}
contexts:
- name: terraform
  context:
    cluster: cluster
    user: terraform
users:
- name: terraform
  user:
    token: ${data.aws_eks_cluster_auth.aws_eks_cluster.token}
EOF
}
*/


# Redeploy coredns pods once fargate is ready to schedule them
# resource "null_resource" "redeploy_coredns_to_fargate" {
#   provisioner "local-exec" {
#     #interpreter = var.local_interpreter
#     command = <<EOF
# kubeconfig=${module.template_files.files.kubeconfig.content}
# kubectl --kubeconfig=$kubeconfig -n kube-system rollout restart deployment coredns
# EOF
#   }

#   depends_on = [
#     module.template_files
#     aws_eks_fargate_profile.kube-system-pod
#   ]
# }

# output "kubeconfig_test" {
#   value     = module.template_files.files.kubeconfig.content
#   sensitive = true
# }