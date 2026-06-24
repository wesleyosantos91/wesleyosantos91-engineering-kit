# Regra: Segurança

## Comandos destrutivos — NUNCA sem confirmação explícita

```bash
rm -rf
git reset --hard
git clean -fdx
docker system prune -a
drop database
terraform apply
kubectl delete
aws * delete*   # qualquer delete na AWS
```

O agente **não executa** esses comandos por conta própria. `terraform apply`,
`kubectl delete` e deletes em AWS/cloud são **ações humanas**. `plan`/dry-run são
permitidos para revisão.

## Segredos — NUNCA exibir, logar ou commitar

```text
tokens, secrets, .env, credenciais AWS, certificados, chaves privadas, dados sensíveis
```

- `scripts/ai/preflight.sh` faz varredura heurística de secrets (read-only) e
  **mascara** valores no output.
- Segredos ficam fora do repo: variáveis de ambiente, secret manager, credenciais
  montadas. Nunca hardcoded.
- Em context-pack, `.env`/chaves/certs são excluídos; `repomix.config.json` tem
  `enableSecurityCheck: true`.

## Mudanças de build/infra

- Não alterar `pom.xml`/`build.gradle` com risco de quebra: criar proposta + `.example`.
- Não instalar dependência global automaticamente.
- Não reestruturar pacotes existentes sem aprovação.
- Não deletar arquivos existentes.
