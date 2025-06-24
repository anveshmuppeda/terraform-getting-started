module "ekscluster" {
    source = "terraform-aws-modules/eks/aws"
    version = "~> 20.0"
    cluster_name = var.cluster_name
    cluster_version = var.cluster_version
    subnet_ids = var.subnets
    vpc_id = var.vpc_id

    tags = {
        Name = var.cluster_name
        Environment = "dev"
    }

    # EKS Add-ons
    cluster_addons = {
        coredns                = {}
        eks-pod-identity-agent = {}
        kube-proxy             = {}
        vpc-cni                = {}
    }

    eks_managed_node_groups = {
        node_ggroup1 = {
            # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
            ami_type       = "AL2_x86_64"
            instance_types = ["t3.medium"]

            min_size = 2
            max_size = 5
            # This value is ignored after the initial creation
            # https://github.com/bryantbiggs/eks-desired-size-hack
            desired_size = 2
        }
        node_ggroup2 = {
            # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
            ami_type       = "AL2_x86_64"
            instance_types = ["t3.medium"]

            min_size = 2
            max_size = 5
            # This value is ignored after the initial creation
            #
            desired_size = 2
        }
    }
}