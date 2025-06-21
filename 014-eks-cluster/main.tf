module "eks_cluster" {
  source = "./modules/eks-cluster"
  eks_cluster_name        = "terraform-eks-cluster"
  eks_cluster_role_name   = "eks-cluster-controlplane-role"
  eks_subnet_ids          = ["subnet-0c01538dcbd0ac1cf", "subnet-0e5e270a5d9a02f2f", "subnet-015bcfb5c18e38d74"] # Replace with your actual subnet IDs
}

module "eks_node_group" {
  source = "./modules/eks-nodes"
  eks_cluster_name            = module.eks_cluster.eks_cluster_name
  eks_subnet_ids              = module.eks_cluster.eks_subnet_ids
  eks_node_role_name          = "eks-worker-node-role"
  eks_node_group_name         = "eks-node-group1"
  eks_node_instance_type      = "t3.medium"
  eks_node_desired_capacity   = 2
  eks_node_max_size           = 3
  eks_node_min_size           = 1
}