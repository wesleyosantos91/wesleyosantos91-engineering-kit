---
description: Registrar uma decisão de arquitetura (ADR).
---

# /adr

**Objetivo:** documentar uma decisão técnica relevante.

**Quando usar:** decisão arquitetural/tecnológica com impacto.

**Agentes envolvidos:** `tech-writer` (+ `java-architect` para contexto).

**Comandos shell permitidos:**
```bash
ls docs/adr/ 2>/dev/null || true
```

**Entradas esperadas:** decisão, contexto, alternativas, consequências.

**Saída esperada:** novo ADR a partir de `.ai/templates/adr-template.md` em `docs/adr/NNNN-*.md`.

**Critério de pronto:** ADR com status, contexto, decisão e consequências preenchidos.

## Contexto adicional
$ARGUMENTS
