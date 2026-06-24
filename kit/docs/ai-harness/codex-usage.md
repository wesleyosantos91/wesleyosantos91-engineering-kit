# Uso com OpenAI Codex CLI

Codex lê `AGENTS.md` (instrução principal) e os prompts em `.ai/prompts/codex/`.

## Setup

- O DevContainer já instala o Codex CLI (`.devcontainer/install-tools.sh`).
- RTK inicializado para Codex (`rtk init -g --codex`) → `~/.codex/AGENTS.md` + `RTK.md`.

## Prompts operacionais

| Intenção | Prompt |
|---|---|
| Planejar | `.ai/prompts/codex/plan.md` |
| Implementar (TDD) | `.ai/prompts/codex/implement-tdd.md` |
| Revisar diff | `.ai/prompts/codex/review.md` |
| Debugar | `.ai/prompts/codex/debug.md` |
| Qualidade | `.ai/prompts/codex/quality.md` |
| OpenSpec | `.ai/prompts/codex/openspec-check.md` |

Cole/aponte o prompt desejado e informe a tarefa.

## Comandos canônicos

```bash
bash scripts/ai/preflight.sh
bash scripts/quality/verify-all.sh --fast
bash scripts/quality/verify-all.sh --full
bash scripts/ai/openspec-validate.sh
```

## Regras que o Codex deve seguir

Todas em `AGENTS.md` e `.ai/rules/`: TDD obrigatório, camadas/pacotes, gates >= 90%,
segurança (sem destrutivo/secrets), economia de contexto, não alterar `pom.xml` com risco.
