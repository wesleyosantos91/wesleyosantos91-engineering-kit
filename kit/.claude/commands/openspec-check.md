---
description: Compara a implementação com OpenSpec/SDD/PRD.
---

# /openspec-check

Valide a implementação contra as specs.

## Passos
1. `bash scripts/ai/openspec-validate.sh` → gera `.ai/reports/openspec-check.md`.
2. Leia a tarefa/change em $ARGUMENTS.
3. Confronte:
   - endpoints/eventos/comandos declarados na spec vs implementados;
   - regras de negócio da spec vs testes existentes;
   - critérios de aceite vs cobertura de teste.
4. Aponte **divergências** spec×código.
5. Se o requisito não estiver claro → **bloqueie** e peça definição de spec.

## Regras
- **Não invente requisitos** (`.ai/rules/openspec-sdd.md`).
- Se não houver OpenSpec, documente a ausência e use o template de fluxo.
