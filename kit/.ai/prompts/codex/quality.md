# Prompt (Codex): quality

Execute os quality gates:

| modo | comando |
|---|---|
| fast | `bash scripts/quality/verify-all.sh --fast` |
| full | `bash scripts/quality/verify-all.sh --full` |
| coverage | `bash scripts/quality/jacoco.sh` |
| mutation | `bash scripts/quality/mutation-test.sh` |
| arch | `bash scripts/quality/archunit.sh` |
| openspec | `bash scripts/ai/openspec-validate.sh` |

Depois, mostre `.ai/reports/quality-summary.md`. **Não esconda falhas**: explique
causa e correção. Gate ausente (plugin não configurado) = **ausente**, não falha;
aponte `config/pom-quality-plugins.example.xml` para habilitar.
