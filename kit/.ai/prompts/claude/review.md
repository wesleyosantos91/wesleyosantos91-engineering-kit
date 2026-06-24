# Prompt (Claude): review

> Equivalente de `.claude/commands/review.md`.

Revise o diff atual; não implemente. Avalie: arquitetura e pacotes; SOLID e riscos
de design (`.ai/rules/solid.md`); testes (unit, regressão de bugfix, integration quando há dependência externa); JaCoCo >= 90% e
PIT >= 90% (se configurados); ArchUnit/package-rules; OpenSpec
(`bash scripts/ai/openspec-validate.sh`); Checkstyle/Spotless; segurança (sem
secrets/destrutivo). Se seguro: `bash scripts/quality/verify-all.sh --fast`.
Saída: lista priorizada com `arquivo:linha`.
