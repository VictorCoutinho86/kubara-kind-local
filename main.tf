resource "terraform_data" "precheck" {
  provisioner "local-exec" {
    command = <<-EOT
      set -e
      for b in kubara kind docker helm kubectl cloud-provider-kind; do
        if ! command -v "$b" >/dev/null 2>&1; then
          echo "ERROR: '$b' not found in PATH" >&2
          exit 1
        fi
      done
      echo "All kubara prerequisites present."
    EOT
  }
}

resource "local_file" "env" {
  content = templatefile("${path.module}/.env.tftpl", {
    project_name    = var.project_name
    project_stage   = var.project_stage
    argocd_password = var.argocd_password
    repo_url        = var.repo_url
    git_username    = var.git_username
    git_pat         = var.git_pat
  })
  filename        = "${path.module}/.env"
  file_permission = "0600"
}

resource "terraform_data" "kubara_init_prep" {
  depends_on = [terraform_data.precheck, local_file.env]

  provisioner "local-exec" {
    command     = "${var.kubara_bin} init --prep --local"
    working_dir = path.module
  }
}

resource "terraform_data" "kubara_init" {
  depends_on = [terraform_data.kubara_init_prep]

  provisioner "local-exec" {
    command     = "${var.kubara_bin} init --local"
    working_dir = path.module
  }
}

resource "terraform_data" "kubara_bootstrap" {
  triggers_replace = {
    cluster           = var.project_name
    kind_bin          = var.kind_bin
    force_rebootstrap = var.force_rebootstrap
  }

  depends_on = [terraform_data.kubara_init]

  provisioner "local-exec" {
    command     = "${var.kubara_bin} bootstrap --local ${var.project_name}"
    working_dir = path.module
  }

  provisioner "local-exec" {
    when        = destroy
    command     = "${self.triggers_replace.kind_bin} delete cluster --name ${self.triggers_replace.cluster}"
    working_dir = path.module
  }
}
