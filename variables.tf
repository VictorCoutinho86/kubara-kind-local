variable "project_name" {
  description = "Name of the platform cluster. Also used as the kind cluster name."
  type        = string
  default     = "test-cluster"
}

variable "project_stage" {
  description = "Stage of the platform (used in secret paths)."
  type        = string
  default     = "local"
}

variable "argocd_password" {
  description = "Initial Argo CD admin password (ARGOCD_WIZARD_ACCOUNT_PASSWORD)."
  type        = string
  default     = "magic"
  sensitive   = true
}

variable "repo_url" {
  description = "HTTPS URL of the GitOps repository Argo CD pulls manifests from (ARGOCD_GIT_HTTPS_URL)."
  type        = string
}

variable "repo_target_revision" {
  description = "Git branch/revision Argo CD targets."
  type        = string
  default     = "main"
}

variable "git_username" {
  description = "Git username for private repositories (ARGOCD_GIT_USERNAME)."
  type        = string
  default     = ""
  sensitive   = true
}

variable "git_pat" {
  description = "Git PAT/password for private repositories (ARGOCD_GIT_PAT_OR_PASSWORD)."
  type        = string
  default     = ""
  sensitive   = true
}

variable "kubara_bin" {
  description = "Path or name of the kubara binary."
  type        = string
  default     = "kubara"
}

variable "kind_bin" {
  description = "Path or name of the kind binary."
  type        = string
  default     = "kind"
}

variable "force_rebootstrap" {
  description = "Change this value (e.g. a timestamp) to force re-running kubara bootstrap."
  type        = string
  default     = ""
}
