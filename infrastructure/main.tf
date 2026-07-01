terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.40.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.0.2"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.19.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.38.0"
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

  role_arn = aws_iam_role.cluster.arn
  version  = "1.35"

  vpc_config {
    subnet_ids = [
      "subnet-04b01c200e3bad13f",
      "subnet-04b8aaf96fe2e8056",
      "subnet-029f16e1381770592"
    ]
  }

  depends_on = [aws_iam_role_policy_attachment.cluster-policy-attachment]
}

#Worker node Creation
resource "aws_eks_node_group" "my-workers" {
  cluster_name    = aws_eks_cluster.my-cluster.name
  node_group_name = "my-workers"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids = [
    "subnet-04b01c200e3bad13f",
    "subnet-04b8aaf96fe2e8056",
    "subnet-029f16e1381770592"
  ]
  instance_types = ["c7i-flex.large"]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 2
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.cluster-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.cluster-AmazonEC2ContainerRegistryReadOnly,
  ]

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



#IAM role for woker node crateion
resource "aws_iam_role" "node" {
  name = "my-node-role"
  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [{

      Effect = "Allow"

      Principal = {
        Service = "ec2.amazonaws.com"
      }

      Action = "sts:AssumeRole"

    }]
  })
}

#Attach policy to EKS Cluster resource
resource "aws_iam_role_policy_attachment" "cluster-policy-attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

#Attach policy to EKS worker node resource
resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "cluster-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "cluster-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node.name
}