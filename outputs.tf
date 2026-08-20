output "cluster_name" {
  description = "Name of the kind cluster and kubara cluster profile."
  value       = var.project_name
}

output "kubeconfig_path" {
  description = "Local kubeconfig written by kubara bootstrap."
  value       = "${path.module}/.local/kind.kubeconfig"
}

output "argocd_port_forward" {
  description = "Command to reach the Argo CD UI without the LoadBalancer IP."
  value       = "kubectl --kubeconfig ${path.module}/.local/kind.kubeconfig port-forward svc/argocd-server -n argocd 8080:443"
}
