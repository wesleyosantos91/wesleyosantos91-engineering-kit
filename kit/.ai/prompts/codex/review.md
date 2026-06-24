# Prompt (Codex): review

Revise o diff atual (`git diff`). Não implemente; aponte achados acionáveis com `arquivo:linha`.

Critérios:
- Arquitetura e pacotes (`.ai/rules/architecture.md`, `.ai/rules/package-organization.md`).
- SOLID e riscos de design (`.ai/rules/solid.md`): SRP/OCP/LSP/ISP/DIP, sem abstração prematura.
- Testes: unit presentes; bugfix com regressão; integration quando há dependência externa.
- Cobertura JaCoCo >= 90% e PIT >= 90% (quando configurados).
- ArchUnit/package-rules sem violações.
- OpenSpec: implementação bate com a spec (`bash scripts/ai/openspec-validate.sh`).
- Checkstyle/Spotless OK. Sem secrets nem comando destrutivo.

Se seguro, rode `bash scripts/quality/verify-all.sh --fast`.
Saída: lista priorizada (bloqueadores → sugestões).
