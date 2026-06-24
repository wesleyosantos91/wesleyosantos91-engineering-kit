---
description: Revisão de segurança defensiva e varredura de secrets.
---

# /security-check

**Objetivo:** encontrar secrets, riscos OWASP e hardening.

**Quando usar:** pré-PR e mudanças sensíveis.

**Agentes envolvidos:** `security-reviewer`.

**Comandos shell permitidos:**
```bash
bash scripts/ai/preflight.sh
bash scripts/hooks/prevent-secret-leak.sh
git diff
```

**Entradas esperadas:** diff/arquivos alvo.

**Saída esperada:** achados por severidade (valores de secrets mascarados).

**Critério de pronto:** sem secrets expostos; riscos críticos endereçados ou aceitos.

## Contexto adicional
$ARGUMENTS
