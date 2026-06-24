# Skills

Skills operacionais amarradas aos scripts/gates locais. Disponíveis para Claude
(`.claude/skills/<nome>/SKILL.md`) e Codex (`.agents/skills/<nome>/SKILL.md`).

## Catálogo (10)

| Skill | Objetivo | Script central |
|---|---|---|
| `java-quality-gate` | Rodar/interpretar gates | `scripts/quality/verify-all.sh` |
| `tdd-implementation` | Implementar via TDD | `scripts/quality/test-unit.sh` |
| `openspec-validation` | Validar spec×código | `scripts/ai/openspec-validate.sh` |
| `package-architecture-review` | SOLID, pacotes e isolamento do domínio | `scripts/quality/package-rules.sh` |
| `mutation-testing-review` | Mutantes sobreviventes | `scripts/quality/mutation-test.sh` |
| `api-contract-review` | Breaking changes | `git diff` + openspec-validate |
| `pre-pr-review` | Checklist pré-PR | `scripts/quality/verify-all.sh --fast` |
| `adr-generation` | Gerar ADR | template `.ai/templates/adr-template.md` |
| `context-pack` | Empacotar contexto | `scripts/ai/context-pack.sh` |
| `prd-produto` | Gerar/revisar PRD de produto (base de conhecimento p/ OpenSpec) | `docs/prd/`, `openspec/` |

Cada SKILL.md tem: frontmatter, objetivo, quando usar / quando NÃO usar, inputs,
workflow, comandos, saída esperada, critérios de qualidade e nota de segurança
(bloqueio de comandos destrutivos).

As skills de **OpenSpec** (`openspec-explore/propose/apply/archive/sync`) já existentes
permanecem e não foram alteradas.

## Fluxo PRD → Spec/SDD

A skill `prd-produto` estabelece o PRD como base de conhecimento de negócio/produto que
**alimenta o OpenSpec**. Cadeia: `PRD (docs/prd/) -> OpenSpec change (openspec/:
proposal/design/tasks) -> TDD`. O planejamento da entrega é uma OpenSpec change criada via
`openspec-propose` / `/opsx propose`, que lê o PRD como base (`openspec/config.yaml`:
`context` + `rules`). Todo PRD salvo é referenciado em `docs/prd/README.md`, `CLAUDE.md` e
`AGENTS.md`; nenhuma change deve ser planejada sem ler antes o PRD de origem e referenciá-lo.
No Claude Code há também o comando `/prd-produto`.

## Validação

```bash
bash scripts/ai/validate-skills.sh
```

## Codex

O Codex CLI **descobre as skills automaticamente** — varre `.agents/skills/` do diretório
atual até a raiz do repositório (e **segue symlinks**, então o `.agents` symlinkado na raiz
do projeto funciona). Nenhum registro manual é necessário: skills com `name` + `description`
no frontmatter já ficam disponíveis (invoque com `/skills` ou `$nome`).

O arquivo `.codex/config.example.toml` serve **apenas para DESABILITAR** skills (override),
via `[[skills.config]]` com `enabled = false` — copie para `.codex/config.toml` só se quiser
desligar alguma. **Não é necessário para ativar/descobrir** as skills.

> Escopos que o Codex varre: repositório (`.agents/skills` de cwd até a raiz), usuário
> (`$HOME/.agents/skills`), admin (`/etc/codex/skills`) e as embutidas pela OpenAI.
> Ref.: https://developers.openai.com/codex/skills

### Paridade Claude × Codex
A maioria das skills está nos dois (`.claude/skills/` e `.agents/skills/`). Exceções:
`harness-init` é só do Claude (onboarding); as `openspec-*` são geridas pelo OpenSpec
(`.codex/skills/`) e não duplicadas em `.agents/skills/`.
