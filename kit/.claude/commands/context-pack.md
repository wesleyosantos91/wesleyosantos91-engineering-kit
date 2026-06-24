---
description: Gera um pacote de contexto econômico do repositório.
---

# /context-pack

Gere um pacote de contexto enxuto para alimentar o raciocínio.

## Passo
- `bash scripts/ai/context-pack.sh` → escreve `.ai/reports/context-pack.md`.
  - Usa `repomix --compress` se disponível; senão, fallback manual.
  - Exclui `target/`, `build/`, `.git/`, `.idea/`, `node_modules/`, binários,
    `.env`, certificados e chaves.

## Regras
- Contexto **cirúrgico**: prefira os arquivos relevantes à tarefa, não o repo todo.
- Preserve headroom; resuma logs grandes mas mantenha stack traces.
- Nunca inclua secrets (`.ai/rules/security.md`, `.ai/rules/token-economy.md`).
