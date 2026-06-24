# Referência: multi-agents

## O repo usado como inspiração

[`wesleyosantos91/multi-agents`](https://github.com/wesleyosantos91/multi-agents) —
catálogo multi-plataforma (Claude/Codex/Copilot/Gemini/Devin) com 24 agentes,
~34 commands, skills, templates e references.

Usado como **benchmark, não contrato**. Análise completa em
[`.ai/reports/multi-agents-reference-review.md`](../../.ai/reports/multi-agents-reference-review.md)
e diff em [`.ai/reports/reference-diff-report.md`](../../.ai/reports/reference-diff-report.md).

## O que foi aproveitado

- Padrão de **orquestrador com triage** → `staff-engineer-orchestrator` (aciona poucos agentes).
- **15 agentes** focados em Java 25 (ver [`agents.md`](./agents.md)).
- **Commands de review** (`/pre-pr`, `/arch-review`, `/qa-review`, `/security-check`, `/contract-review`, `/local-setup`, `/docs`, `/adr`, `/agents`, `/spawn-review-team`).
- **9 skills** amarradas aos scripts/gates locais (ver [`skills.md`](./skills.md)).
- **References/templates** (severidade, evidência, tamanho de mudança, política de gate, seleção de agentes; ADR, finding, pré-PR checklist).
- Padrão de **hooks de segurança** (como exemplos, desativados).
- Padrão de **config Codex** (como `.codex/config.example.toml`).

## O que foi descartado (e por quê)

- Agentes de outras stacks (Python/Go/Frontend/Mobile/Jakarta/Data) — não há essas stacks aqui.
- Reviewers fora do foco (FinOps/Compliance/Incident/DBA) — sem necessidade atual.
- Plataformas Copilot/Gemini/Devin — foco é Claude Code + Codex.
- Catálogo gigante de skills de frameworks não usados.
- Hooks/`config.toml` ativos por padrão — risco operacional.

Backlog detalhado: [`agents-backlog.md`](./agents-backlog.md).

## Por que este harness é menor e mais focado

- Uma stack (**Java 25**), duas plataformas (**Claude + Codex**).
- Gates **reais no `pom.xml`** (Spotless/Checkstyle/JaCoCo 90%/PIT 90%/ArchUnit) — não genéricos.
- Agentes **referenciam** `.ai/rules/` e `scripts/` em vez de duplicar conhecimento.
- "Mínimo viável de agentes" por tarefa → menos ruído, mais headroom, manutenção baixa.

## Como atualizar no futuro

1. Atualizar o clone:
   ```bash
   git clone --depth 1 https://github.com/wesleyosantos91/multi-agents /tmp/multi-agents-reference
   ```
2. Rodar `bash scripts/ai/reference-diff-report.sh` e revisar o diff.
3. Promover do backlog apenas o que atender aos critérios de `agents-backlog.md`.
4. Em conflito, **prevalece o harness local**.
