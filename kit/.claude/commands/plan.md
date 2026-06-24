---
description: Diagnóstico e plano de implementação, sem editar código.
---

# /plan

Você é o AI Harness Engineer deste repositório Java. **Não edite código** neste comando.

## Passos

1. Rode (read-only):
   - `bash scripts/ai/preflight.sh`
   - `bash scripts/ai/detect-project.sh`
   - `bash scripts/ai/openspec-validate.sh`
2. Leia a tarefa em: $ARGUMENTS
3. Confirme contexto mínimo com `bash scripts/ai/opsx-context-check.sh <arquivo>` se houver.
4. Produza um plano curto contendo:
   - objetivo e requisito (referencie spec/OpenSpec se existir)
   - arquivos prováveis (camadas: web/application/domain/infrastructure)
   - estratégia de teste (unit obrigatório; integration se houver dependência externa; BDD se houver regra de negócio)
   - critério de pronto **testável**
   - riscos e rollback
5. **Não** comece a implementar. Aguarde confirmação.

## Regras
- Respeite `.ai/rules/architecture.md` e `.ai/rules/package-organization.md`.
- Não invente requisitos (`.ai/rules/openspec-sdd.md`).
- Economize contexto (`.ai/rules/token-economy.md`).
