---
description: Revisa o diff atual (arquitetura, testes, gates, OpenSpec).
---

# /review

Revise o diff atual. **Não implemente**; aponte achados acionáveis.

## Passos
1. `git status --short` e `git diff` (ou diff vs base).
2. Avalie contra os critérios abaixo.
3. Rode, se seguro: `bash scripts/quality/verify-all.sh --fast`.

## Critérios
- **Arquitetura**: camadas respeitadas? domínio sem tecnologia? (`.ai/rules/architecture.md`)
- **Pacotes**: organização correta? (`.ai/rules/package-organization.md`)
- **Testes**: unit presentes? bugfix com regressão? integration quando há dependência externa?
- **TDD**: o teste justifica a produção?
- **Cobertura/Mutação**: JaCoCo >= 90% e PIT >= 90% (quando configurados).
- **ArchUnit/package-rules**: sem violações.
- **OpenSpec**: implementação bate com a spec? (`bash scripts/ai/openspec-validate.sh`)
- **Estilo**: Checkstyle/Spotless OK.
- **Segurança**: sem secrets, sem comando destrutivo.

## Saída
Lista priorizada (bloqueadores → sugestões), citando `arquivo:linha`.
