# kubara-kind-local

Sobe uma plataforma Kubernetes local com [kubara](https://kubara.io) usando o preset `kind`, orquestrado por Terraform.

O Terraform **não** cria o cluster kind diretamente — ele gera o `.env` e dispara a sequência do kubara (`init` → `bootstrap`), que cria o cluster kind e instala os serviços (Argo CD, OpenBao, Traefik, kube-prometheus-stack, etc.).

## Pré-requisitos

Binários no `PATH` (verificados no precheck do Terraform):

- `kubara`
- `kind`
- `docker` (ou `podman`) — **Docker Desktop precisa estar rodando**
- `helm`
- `kubectl`
- `cloud-provider-kind`

## Como usar

```bash
# 1. Configurar variáveis
cp terraform.tfvars.example terraform.tfvars
#    edite terraform.tfvars e preencha repo_url (obrigatório)

# 2. Iniciar
terraform init
terraform apply
```

O `apply` executa, em ordem:

1. `precheck` — valida os binários
2. gera `.env` a partir de `terraform.tfvars`
3. `kubara init --prep --local` — copia `.gitignore`
4. `kubara init --local` — gera `config.yaml`
5. `kubara bootstrap --local <project_name>` — cria o cluster kind + Argo CD + OpenBao

## Passo manual obrigatório

O `kubara bootstrap --local` **bloqueia** esperando o IP do `LoadBalancer` do Traefik. Enquanto o `apply` roda, abra **outro terminal** e execute:

```bash
sudo cloud-provider-kind
```

Deixe rodando. O bootstrap destrava em segundos quando o IP é atribuído.

> macOS + Colima: se travar em `Waiting for the local Traefik LoadBalancer IP`, reinicie o `cloud-provider-kind` (veja troubleshooting na doc oficial).

## Acessar

```bash
# Argo CD via port-forward (usuário: wizard / senha: var.argocd_password)
kubectl --kubeconfig .local/kind.kubeconfig port-forward svc/argocd-server -n argocd 8080:443
# http://localhost:8080/argocd

# Ou via ingress (IP dinâmico do LoadBalancer)
# https://<lb-ip>.traefik.me/argocd
```

## Re-executar / limpar

```bash
# Reforçar o bootstrap (ex.: depois de um timeout)
terraform apply -var="force_rebootstrap=$(date +%s)"

# Destruir o cluster kind
terraform destroy
```

`terraform destroy` roda `kind delete cluster --name <project_name>`.
