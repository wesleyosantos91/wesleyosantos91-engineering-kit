---
description: Revisão de contrato de API (breaking changes).
---

# /contract-review

**Objetivo:** detectar breaking changes e validar versionamento.

**Quando usar:** qualquer mudança de API (REST/Async/GraphQL/gRPC/schema).

**Agentes envolvidos:** `api-contract-reviewer` (+ `openspec-reviewer`).

**Comandos shell permitidos:**
```bash
git diff
bash scripts/ai/openspec-validate.sh
```

**Entradas esperadas:** contrato/spec e código `web/api`.

**Saída esperada:** matriz de compatibilidade + decisão.

**Critério de pronto:** sem breaking change sem versionamento/migração.

## Contexto adicional
$ARGUMENTS
