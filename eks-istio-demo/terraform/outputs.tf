output "cluster_name" {
  value = module.eks.cluster_id
}

output "kubeconfig" {
  value = module.eks.kubeconfig
  description = "Kubeconfig content (sensitive)"
}
