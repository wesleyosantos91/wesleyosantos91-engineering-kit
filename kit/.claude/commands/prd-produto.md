---
description: Transformar ideia/dor/épico/feature em PRD de produto (fonte de verdade para Spec/SDD).
---

# /prd-produto

**Objetivo:** transformar uma ideia, dor, oportunidade, demanda, épico ou feature em um
PRD focado em requisitos de negócio e produto, mantendo o PRD como fonte de verdade para
specs e SDDs derivadas.

**Quando usar:** PRD, requisitos de produto, discovery de demanda, recorte de MVP, revisão
de PRD, perguntas de refinamento ou validação de prontidão antes de uma SDD/spec.

**Skill envolvida:** `prd-produto` (`.claude/skills/prd-produto/SKILL.md`; no Codex use a
mesma skill em `.agents/skills/prd-produto/SKILL.md`).

**Modos disponíveis:** `auto` (padrão) · `discovery` · `lean` · `completo` · `review` ·
`mvp` · `perguntas` · `salvar` · `referenciar` · `pre-sdd`.

**Comandos shell permitidos:**
```bash
ls docs/prd/ 2>/dev/null || true
ls openspec/changes/ 2>/dev/null || true
```

**Entradas esperadas:** modo (opcional) + descrição da demanda, ou um caminho de PRD
(ex.: `review docs/prd/<arquivo>.md`, `pre-sdd docs/prd/<arquivo>.md`).

**Saída esperada:** artefato do modo escolhido (Discovery Brief, PRD Lean, PRD Completo,
review, recorte de MVP, perguntas ou pré-validação para a OpenSpec change), com premissas,
perguntas abertas, riscos e sugestão de caminho `docs/prd/<nome-da-iniciativa>.md`.

**Regras do fluxo PRD → OpenSpec:**
- Todo PRD salvo fica em `docs/prd/<nome-da-iniciativa>.md` e é referenciado em
  `docs/prd/README.md`, `CLAUDE.md` e `AGENTS.md`.
- O planejamento da entrega é uma **OpenSpec change** (`/opsx propose`) que lê o PRD como
  base (`openspec/config.yaml`) e o referencia; o design/plano técnico (SDD) fica no
  `design.md` da change.
- O PRD é a fonte de verdade de negócio/produto; a change é derivada do PRD.

**Critério de pronto:** artefato gerado no modo correto; se o usuário pediu para salvar,
o arquivo está em `docs/prd/` e referenciado em `docs/prd/README.md`, `CLAUDE.md` e
`AGENTS.md`. Não criar código, arquitetura ou a OpenSpec change neste comando.

## Contexto adicional
$ARGUMENTS
