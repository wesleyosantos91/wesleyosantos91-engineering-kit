# Prompt (Codex): implement-tdd

Implemente seguindo **TDD obrigatório** (`.ai/rules/tdd.md`).

Fluxo: entender requisito → **teste falhando** → `bash scripts/quality/test-unit.sh`
(confirmar red) → implementação mínima → verde → refatorar → `bash scripts/quality/verify-all.sh --fast`
→ `bash scripts/ai/task-report.sh`.

Bugfix: reproduzir com teste falhando → corrigir → provar passando → regressão.

Regras:
- Nenhuma produção antes de um teste falhando.
- Camadas/pacotes (`.ai/rules/architecture.md`); domínio sem Spring/JPA/AWS/Kafka.
- SOLID obrigatório (`.ai/rules/solid.md`): evitar service com múltiplas responsabilidades, interface sem consumidor real, herança desnecessária e vazamento de DTO/entity para domínio.
- Não alterar `pom.xml` com risco — propor via `config/pom-quality-plugins.example.xml`.
- Não rodar comando destrutivo; não deletar arquivos; não reestruturar pacotes sem aprovação.
- Saída: diff claro + `.ai/reports/task-report.md`.
