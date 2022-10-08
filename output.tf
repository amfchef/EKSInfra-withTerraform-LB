output "cluster_id" {
  description = "EKS cluster ID"
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}
/*
aws eks --region eu-west-1 update-kubeconfig \
    --name $(terraform output -raw cluster_id)

output "aws_load_balancer_controller_role_arn" {
  value = kubernetes_ingress_v1.node.
}
*/
# http://ab64f9d287da0494fac61a41f2fa1aac-598597091.eu-west-1.elb.amazonaws.com/
