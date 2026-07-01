resource "aws_eks_access_entry" "admin" {
  cluster_name  = aws_eks_cluster.my-cluster.name
  principal_arn = "arn:aws:iam::099090990644:user/admin"
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "admin" {
  cluster_name  = aws_eks_cluster.my-cluster.name
  principal_arn = aws_eks_access_entry.admin.principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}