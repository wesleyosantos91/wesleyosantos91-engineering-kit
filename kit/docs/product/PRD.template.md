# PRD — <nome do produto/feature> (TEMPLATE)

> Template de Product Requirements Document. **Não contém requisitos reais** — preencha.
> O PRD alimenta o fluxo SDD: `PRD -> OpenSpec -> SDD/plano -> TDD -> testes`.

- **Status:** rascunho | em revisão | aprovado
- **Autor:** <nome>
- **Data:** <AAAA-MM-DD>
- **Stakeholders:** <quem decide / valida>

## 1. Problema
<Qual dor do usuário/negócio? Evidência?>

## 2. Objetivo e métricas de sucesso
<Resultado esperado + métricas mensuráveis (ex.: latência, conversão, erro).>

## 3. Usuários / personas
<Quem usa e em que contexto.>

## 4. Escopo
- **Dentro do escopo:** <...>
- **Fora do escopo (não-objetivos):** <...>

## 5. Requisitos funcionais
<Lista numerada, observável e verificável.>
- RF1: <...>
- RF2: <...>

## 6. Requisitos não-funcionais
<Performance, segurança, observabilidade, compliance, disponibilidade.>

## 7. Regras de negócio
<Invariantes do domínio. Estas viram testes e specs OpenSpec.>

## 8. Critérios de aceite
<Testáveis. Cada um deve poder virar teste automatizado (TDD/BDD).>
- [ ] <...>

## 9. Riscos e dependências
<Externas: banco, mensageria, AWS, terceiros. Indicam testes de integração.>

## 10. Rollout / rollback
<Como liberar e como reverter.>

---

### Próximo passo
Transformar os requisitos/regras em uma **change OpenSpec** (`openspec/changes/<id>/`)
e então em plano técnico (SDD) antes de implementar via TDD.
