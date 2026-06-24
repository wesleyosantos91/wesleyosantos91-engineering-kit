# Agentes

Camada de agentes do harness, focada em **Java 25 + Claude Code + Codex**. Inspirada
em `wesleyosantos91/multi-agents`, mas o harness local é a fonte da verdade.

- Claude: `.claude/agents/*.md` (frontmatter `name/description/tools/model`).
- Codex: `.codex/agents/*.toml` (`developer_instructions`, `sandbox_mode`).

## Catálogo (15)

| Agente | Papel | Implementa? |
|---|---|---|
| `staff-engineer-orchestrator` | Maestro: triage, aciona poucos agentes, GO/NO-GO | Não (delega) |
| `java-architect` | Arquitetura/camadas/pacotes | Não |
| `java-specialist` | Idiomatismo Java 25 e ecossistema | Não |
| `tdd-engineer` | Implementa via TDD | **Sim** (guiado por teste) |
| `test-architect` | Estratégia de testes, cobertura, mutação | Não |
| `quality-gate-engineer` | Executa/interpreta gates | Não |
| `openspec-reviewer` | Spec×código, bloqueia ambiguidade | Não |
| `security-reviewer` | Segurança defensiva, secrets | Não |
| `context-engineer` | Economia de contexto/tokens | Não |
| `devcontainer-engineer` | Ambiente DevContainer/Linux | Não |
| `api-contract-reviewer` | Contratos de API, breaking changes | Não |
| `sre-observability-reviewer` | Observabilidade/resiliência | Não |
| `cicd-release-engineer` | CI/CD, gates na pipeline | Não |
| `performance-reliability-reviewer` | Performance/confiabilidade | Não |
| `tech-writer` | Documentação | Edita só `.md` |

## Seleção

O orquestrador aciona o **mínimo viável** por demanda — ver
[`.ai/references/agent-selection-matrix.md`](../../.ai/references/agent-selection-matrix.md)
e [`multi-agent-workflows.md`](./multi-agent-workflows.md). Nunca todos por padrão.

## Validação

```bash
bash scripts/ai/validate-claude-agents.sh
bash scripts/ai/validate-codex-agents.sh
bash scripts/ai/agent-team-report.sh
```
