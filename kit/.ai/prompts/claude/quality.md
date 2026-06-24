# Prompt (Claude): quality

> Equivalente de `.claude/commands/quality.md`.

Modos: `fast` → `verify-all.sh --fast`; `full` → `verify-all.sh --full`;
`coverage` → `jacoco.sh`; `mutation` → `mutation-test.sh`; `arch` → `archunit.sh`;
`openspec` → `scripts/ai/openspec-validate.sh`. (scripts em `scripts/quality/`).

Depois, mostre `.ai/reports/quality-summary.md`. Não esconda falhas: explique causa
e correção. Gate ausente = ausente (não falha); aponte
`config/pom-quality-plugins.example.xml` para habilitar.
