# AI Engineering Harness

Harness local, versionado, auditável e **vendor-neutral** para uso com **Claude Code**
e **OpenAI Codex CLI** neste repositório Java (Java 25 / Maven / Spring Boot 4).

## Mapa

| Onde | O quê |
|------|-------|
| `AGENTS.md` | Instrução principal para Codex e outros agentes |
| `CLAUDE.md` | Instrução enxuta para Claude Code (+ bloco RTK gerenciado) |
| `.ai/harness.yaml` | Manifesto central (config do harness) |
| `.ai/rules/` | Regras detalhadas (arquitetura, SOLID, TDD, testes, gates, segurança…) |
| `.ai/prompts/{codex,claude}/` | Prompts operacionais por agente |
| `.ai/reports/` | Relatórios gerados (quality, openspec, context, task) |
| `.claude/commands/` | Slash-commands do Claude Code |
| `scripts/ai/` | preflight, detect, context-pack, openspec, report |
| `scripts/quality/` | gates: format, checkstyle, testes, jacoco, pit, archunit |
| `config/` | checkstyle, spotless, archunit, pitest + `pom-quality-plugins.example.xml` |
| `docs/ai-harness/` | esta documentação |
| `docs/product/` | `PRD.template.md` |

## Documentos

- [operating-model.md](./operating-model.md) — como o harness opera (papéis, ciclo).
- [context-strategy.md](./context-strategy.md) — economia de tokens/contexto.
- [quality-gates.md](./quality-gates.md) — todos os gates e como rodar.
- [java-25-quality.md](./java-25-quality.md) — Checkstyle/Spotless/JaCoCo/PIT/ArchUnit.
- [../../.ai/rules/solid.md](../../.ai/rules/solid.md) — SOLID e riscos de design.
- [tdd-flow.md](./tdd-flow.md) — fluxo TDD obrigatório.
- [bdd-flow.md](./bdd-flow.md) — BDD quando aplicável.
- [codex-usage.md](./codex-usage.md) — uso com Codex CLI.
- [claude-code-usage.md](./claude-code-usage.md) — uso com Claude Code.
- [mcp-setup.md](./mcp-setup.md) — MCPs gratuitos para Claude Code, Codex CLI, DevContainer e Linux.
- [openspec-sdd-flow.md](./openspec-sdd-flow.md) — fluxo SDD/OpenSpec/PRD.

## Começo rápido

```bash
bash scripts/ai/preflight.sh
bash scripts/ai/detect-project.sh
bash scripts/quality/verify-all.sh --fast
bash scripts/quality/quality-summary.sh
```
