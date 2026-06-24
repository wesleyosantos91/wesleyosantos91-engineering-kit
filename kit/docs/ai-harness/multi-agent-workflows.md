# Multi-agent workflows

O `staff-engineer-orchestrator` coordena. Princípio: **mínimo viável de agentes**,
preservando headroom. Conflitos resolvidos a favor do harness local.

## Fluxos

### Bug simples
`tdd-engineer` (+ `test-architect` se o teste for frágil).
→ reproduzir com teste falhando → corrigir → regressão.

### Mudança de domínio
`openspec-reviewer` → `java-architect` → `tdd-engineer` → `test-architect` → `quality-gate-engineer`.
→ spec validada → arquitetura ok → TDD → cobertura/mutação → gates.

### Mudança de API
`openspec-reviewer` → `api-contract-reviewer` → `java-architect` → `test-architect` → `quality-gate-engineer`.
→ breaking changes e versionamento antes de implementar.

### Pré-PR (`/pre-pr`)
`context-engineer` → `java-architect` → `test-architect` → `security-reviewer` → `openspec-reviewer` → `quality-gate-engineer`.
→ relatório GO/NO-GO (`.ai/templates/pre-pr-checklist.md`).

### DevContainer (`/local-setup`)
`devcontainer-engineer` → `context-engineer` → `quality-gate-engineer`.

### Incidente / performance
`performance-reliability-reviewer` → `sre-observability-reviewer` → `test-architect`.

### CI/CD / release
`cicd-release-engineer` → `quality-gate-engineer` → `security-reviewer`.

## Consolidação

1. Cada agente entrega achados (`.ai/templates/agent-finding-template.md`) com severidade
   (`.ai/references/review-severity-matrix.md`) e evidência (`.ai/references/evidence-rules.md`).
2. O orquestrador separa **críticos** (bloqueiam) de **melhorias**.
3. Decisão final **GO / NO-GO**.

## Anti-overengineering

- Não acionar todos os agentes por padrão.
- Não trazer agentes de stacks inexistentes (ver `agents-backlog.md`).
- Reusar `.ai/rules/` e `scripts/` em vez de duplicar conhecimento.
