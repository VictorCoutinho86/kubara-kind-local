# gitops

Pasta para os serviços desejados da plataforma.

O kubara gera os serviços (Helm/Argo CD) em `platform-components/` e `platform-configs/` na raiz do projeto durante `terraform apply`. Use esta pasta para guardar catálogos customizados, overlays e manifests adicionais que não são gerados automaticamente.

## Estrutura sugerida

- `catalogs/` — catálogos kubara customizados (`kubara catalog create ...`)
- `overlays/` — arquivos `values-*.yaml` adicionais por serviço
- `apps/` — AppSets/Applications de onboarding de workloads
