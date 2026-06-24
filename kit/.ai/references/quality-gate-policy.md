# Política de quality gates

Fonte: `pom.xml` + `scripts/quality/`. Ver `docs/ai-harness/quality-gates.md`.

| Gate | Regra | Bloqueia? |
|---|---|---|
| Spotless | formatação (Eclipse JDT, Java 25) | Sim, se configurado e falhar |
| Checkstyle | estilo Java 25 | Sim, se configurado e falhar |
| Unit tests | JUnit 5 | Sim |
| Integration | Failsafe `*IT` (quando há dependência externa) | Sim, se houver IT sem runner |
| JaCoCo | line+branch >= 90% | Sim (quando há código mensurável) |
| PIT | mutation score >= 90% | Sim (quando há código mutável) |
| ArchUnit / package-rules | isolamento do domínio | Sim |

Regras:
- **Nunca** baixar thresholds para facilitar o build.
- Gate ausente (plugin não configurado) = reportar como ausente, não falha injusta.
- Não esconder falhas; explicar causa e correção.
