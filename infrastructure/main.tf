terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "6.40.0"
    }
  }
}

provider "aws" {
    region = "ap-south-1"
  
}

#Cluster Creation
resource "aws_eks_cluster" "my-cluster" {
  name = "my-cluster"
  access_config {
    authentication_mode = "API"
  }

  role_arn = aws_iam_role.clustre.arn
  version = "1.35"

  vpc_config {
    subnet_ids = [
        "subnet-04b01c200e3bad13f",
        "subnet-04b8aaf96fe2e8056",
        "subnet-029f16e1381770592"
    ]
  }

  depends_on = [ aws_iam_role_policy_attachment.clister-policy-attachment ]
}

#Worker node Creation
resource "aws_eks_node_group" "my-workers" {
  cluster_name = aws_eks_cluster.my-cluster.name
  node_group_name = "my-workers"
  node_role_arn = aws_iam_role.cluster
  subnet_ids = [
        "subnet-04b01c200e3bad13f",
        "subnet-04b8aaf96fe2e8056",
        "subnet-029f16e1381770592"
  ]

  scaling_config {
    desired_size = 2
    max_size = 3
    min_size = 2
  }

}


#IAM role for Cluster creation
resource "aws_iam_role" "cluster" {
  name = "my-cluster-role"

  assume_role_policy = jsonencode({
     Version = "2012-10-17"
        Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

#Attach policy to EKS resource
resource "aws_iam_role_policy_attachment" "clister-policy-attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = aws_iam_role.clustre.name  
}