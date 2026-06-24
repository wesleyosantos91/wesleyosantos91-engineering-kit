# Operating model

## Princípio

O harness torna o trabalho do agente **determinístico e auditável**: contexto
controlado, comandos canônicos, gates objetivos e rastreabilidade de cada tarefa.

## Ciclo de uma tarefa

```text
inspect -> plan -> failing test -> minimal implementation -> refactor -> quality gates -> report
```

1. **inspect** — `scripts/ai/preflight.sh` + `detect-project.sh` (read-only).
2. **plan** — `/plan` (Claude) ou prompt `plan` (Codex). Sem editar código.
3. **failing test** — TDD: teste falhando primeiro (`.ai/rules/tdd.md`).
4. **minimal implementation** — o mínimo para o teste passar.
5. **refactor** — mantendo verde e revisando SOLID/riscos de design (`.ai/rules/solid.md`).
6. **quality gates** — `scripts/quality/verify-all.sh` (`--fast` no loop, `--full` antes de fechar).
7. **report** — `scripts/ai/task-report.sh` → `.ai/reports/task-report.md`.

## Papéis

- **Agente (Claude/Codex)**: executa o ciclo, respeita regras, gera relatórios.
- **Humano**: aprova plano, revisa diff, executa ações destrutivas/externas
  (`terraform apply`, deploy, deletes).

## Rastreabilidade

Cada tarefa deixa rastros em `.ai/reports/`: `quality-summary.md`, `openspec-check.md`,
`context-pack.md`, `task-report.md`. Em repo git, o diff e o commit complementam.

## Vendor-neutralidade

As regras e scripts não dependem de um agente específico. Claude e Codex consomem o
mesmo conjunto (`.ai/`, `scripts/`, `config/`). Trocar de agente não muda os gates.
