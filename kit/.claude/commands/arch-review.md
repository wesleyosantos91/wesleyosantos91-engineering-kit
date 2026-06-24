---
description: Revisão de arquitetura e organização de pacotes.
---

# /arch-review

**Objetivo:** validar camadas, isolamento do domínio, pacotes, SOLID e riscos de design.

**Quando usar:** mudança de domínio/estrutura.

**Agentes envolvidos:** `java-architect` (+ `java-specialist` se houver dúvida de idiomatismo).

**Comandos shell permitidos:**
```bash
bash scripts/quality/package-rules.sh
bash scripts/quality/archunit.sh
```

**Entradas esperadas:** pacotes/arquivos alvo.

**Saída esperada:** achados de arquitetura/SOLID por severidade, com princípio violado e risco concreto.

**Critério de pronto:** sem violações de camada/SOLID (ou plano para corrigi-las).

## Contexto adicional
$ARGUMENTS
