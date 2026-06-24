---
description: Executa os quality gates (fast/full/coverage/mutation/arch/openspec).
---

# /quality

Execute os quality gates conforme o argumento em $ARGUMENTS.

| argumento | ação |
|---|---|
| `fast` | `bash scripts/quality/verify-all.sh --fast` |
| `full` | `bash scripts/quality/verify-all.sh --full` |
| `coverage` | `bash scripts/quality/jacoco.sh` |
| `mutation` | `bash scripts/quality/mutation-test.sh` |
| `arch` | `bash scripts/quality/archunit.sh` |
| `openspec` | `bash scripts/ai/openspec-validate.sh` |

Sem argumento → `fast`.

## Depois
- Mostre o resumo de `.ai/reports/quality-summary.md`.
- **Não esconda falhas.** Se um gate falhar, explique causa provável e correção.
- Se um gate estiver ausente (plugin não configurado), reporte como **ausente**,
  não como falha, e aponte como habilitar (`config/pom-quality-plugins.example.xml`).
