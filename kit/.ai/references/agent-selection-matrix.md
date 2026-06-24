# Matriz de seleção de agentes

O `staff-engineer-orchestrator` usa esta matriz. Acione o **mínimo viável**.

| Demanda | Agentes |
|---|---|
| Bug simples | `tdd-engineer` (+ `test-architect` se teste frágil) |
| Mudança de domínio | `openspec-reviewer`, `java-architect`, `tdd-engineer`, `test-architect`, `quality-gate-engineer` |
| Mudança de API | `openspec-reviewer`, `api-contract-reviewer`, `java-architect`, `test-architect`, `quality-gate-engineer` |
| Pré-PR | `context-engineer`, `java-architect`, `test-architect`, `security-reviewer`, `openspec-reviewer`, `quality-gate-engineer` |
| DevContainer | `devcontainer-engineer`, `context-engineer`, `quality-gate-engineer` |
| Incidente / performance | `performance-reliability-reviewer`, `sre-observability-reviewer`, `test-architect` |
| CI/CD / release | `cicd-release-engineer`, `quality-gate-engineer`, `security-reviewer` |
| Documentação | `tech-writer` |

Princípios: não acionar todos por padrão; preservar headroom; consolidar conflitos
priorizando o harness local.
