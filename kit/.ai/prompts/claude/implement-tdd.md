# Prompt (Claude): implement-tdd

> Equivalente de `.claude/commands/implement-tdd.md`.

Implemente com **TDD obrigatório** (`.ai/rules/tdd.md`):
entender requisito → **teste falhando** → confirmar red (`bash scripts/quality/test-unit.sh`)
→ implementação mínima → verde → refatorar → `bash scripts/quality/verify-all.sh --fast`
→ `bash scripts/ai/task-report.sh`.

Bugfix: reproduzir com teste falhando → corrigir → provar → regressão.

Regras: nenhuma produção antes do teste falhando; respeitar camadas/pacotes; domínio
sem Spring/JPA/AWS/Kafka; SOLID obrigatório (`.ai/rules/solid.md`); não alterar `pom.xml` com risco (propor `.example`); sem
comandos destrutivos; não deletar arquivos; não reestruturar pacotes sem aprovação.
Saída: diff claro + `.ai/reports/task-report.md`.
