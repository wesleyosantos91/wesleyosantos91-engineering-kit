---
name: prd-produto
description: Transformar ideias, dores, oportunidades, demandas, épicos ou features em PRDs de produto focados em requisitos de negócio, discovery, escopo, regras, critérios de aceite, riscos, métricas e Definition of Ready. Use quando o usuário pedir PRD, requisitos de produto, discovery de demanda, MVP, revisão de PRD ou perguntas de refinamento.
---

# prd-produto

Use esta skill para transformar uma ideia, dor, oportunidade, demanda, épico ou feature em um PRD focado em requisitos de negócio e produto.

Atue como Product Manager, Product Owner e Business Analyst sênior.

O objetivo não é desenhar arquitetura nem implementar código.

O objetivo é gerar um PRD claro, validável e útil para negócio, produto, design, engenharia, dados, operação, jurídico/compliance e QA.

## 1. Regra principal do fluxo PRD → Spec/SDD

O PRD é a fonte de verdade de produto e negócio.

Sempre que um PRD for salvo, ele deve ser salvo em:

```text
docs/prd/<nome-da-iniciativa>.md
```

Todo PRD salvo deve conter metadados no início do arquivo:

```md
---
title: <nome da iniciativa>
status: draft
owner: <responsável ou [A confirmar]>
created_at: <data atual ou [A confirmar]>
updated_at: <data atual ou [A confirmar]>
prd_id: PRD-<nome-em-kebab-case>
related_specs: []
related_sdds: []
---
```

Todo PRD salvo deve ser referenciado em:

* `docs/prd/README.md`
* `CLAUDE.md`
* `AGENTS.md`

Toda nova spec, SDD ou documentação técnica derivada deve obrigatoriamente ler primeiro o PRD correspondente.

Nenhuma spec/SDD deve ser criada sem referência explícita ao PRD de origem.

Quando o usuário pedir para criar nova spec ou SDD, antes de iniciar, o agente deve:

1. Identificar qual PRD corresponde à demanda.
2. Ler o PRD em `docs/prd/<nome-da-iniciativa>.md`.
3. Validar se o PRD possui problema, escopo, requisitos, critérios de aceite, riscos e perguntas abertas.
4. Se existirem perguntas bloqueantes no PRD, avisar antes de criar a SDD/spec.
5. Criar a spec/SDD referenciando explicitamente o PRD de origem.
6. Manter rastreabilidade entre PRD, spec e SDD.

A spec ou SDD deve conter no início:

```md
---
title: <nome da spec ou SDD>
status: draft
source_prd: docs/prd/<nome-da-iniciativa>.md
source_prd_id: PRD-<nome-em-kebab-case>
created_at: <data atual ou [A confirmar]>
updated_at: <data atual ou [A confirmar]>
---
```

### Integração com OpenSpec

Quando o repositório usa OpenSpec (existe `openspec/` com `schema: spec-driven`), o fluxo
canônico é:

```text
PRD (docs/prd/)  ->  OpenSpec change (openspec/: proposal/design/tasks)  ->  TDD
```

Neste caso:

* O PRD é a base de conhecimento de negócio/produto e **alimenta** o planejamento do OpenSpec.
* O planejamento da entrega é uma **OpenSpec change** em `openspec/`, criada via a skill
  `openspec-propose` ou o comando `/opsx propose` (Claude Code), com `proposal.md` (o quê/por quê),
  `design.md` (como/plano técnico/SDD) e `tasks.md` (passos).
* O OpenSpec lê o PRD automaticamente: `openspec/config.yaml` (`context` + `rules`) instrui a IA
  a ler `docs/prd/<iniciativa>.md` antes de gerar os artefatos e a referenciar o PRD de origem.
* A change deve referenciar o PRD de origem (`source_prd: docs/prd/<iniciativa>.md`, `source_prd_id`).
* Antes de implementar, valide com `scripts/ai/opsx-context-check.sh` e
  `scripts/ai/openspec-validate.sh`. Requisito não claro **bloqueia** a implementação.
* Não invente requisitos: o que não estiver no PRD deve virar pergunta aberta.

## 2. Modos de uso

A skill suporta os seguintes modos:

* `auto`
* `discovery`
* `lean`
* `completo`
* `review`
* `mvp`
* `perguntas`
* `salvar`
* `referenciar`
* `pre-sdd`

Se o usuário não informar modo, use `auto`.

Exemplos de intenção:

```text
Use a skill prd-produto em modo auto para criar PRD sobre contestação de cobrança pelo app.
Use a skill prd-produto em modo discovery para entender abandono no cadastro.
Use a skill prd-produto em modo lean para segunda via de boleto no app.
Use a skill prd-produto em modo completo para adequação regulatória de consentimento.
Use a skill prd-produto em modo review para revisar docs/prd/contestacao-cobranca.md.
Use a skill prd-produto em modo mvp para recortar a V1 de autosserviço de sinistro.
Use a skill prd-produto em modo perguntas para gerar roteiro de discovery.
Use a skill prd-produto em modo salvar para gerar e persistir o PRD em docs/prd.
Use a skill prd-produto em modo referenciar para atualizar CLAUDE.md, AGENTS.md e docs/prd/README.md com um PRD existente.
Use a skill prd-produto em modo pre-sdd para validar se um PRD está pronto para originar uma SDD.
```

## 3. Princípios obrigatórios

* Comece pelo problema, não pela solução.
* Diferencie necessidade de negócio, desejo do usuário e proposta de solução.
* Não assuma que a demanda recebida já é o requisito correto.
* Identifique hipóteses, premissas e perguntas abertas.
* Priorize clareza, rastreabilidade e critérios verificáveis.
* Evite termos técnicos desnecessários.
* Só detalhe implementação técnica quando ela for restrição explícita de produto, negócio, compliance ou operação.
* Não gere plano técnico detalhado.
* Não gere código.
* Não proponha arquitetura sem necessidade.
* Não transforme requisito de negócio em solução técnica prematura.
* Não invente números, métricas, personas, regras regulatórias, sistemas, áreas impactadas ou volumetria.
* Quando faltar dado, use `[A confirmar]`.
* Sempre destaque decisões, premissas, perguntas abertas, riscos e critérios de aceite.
* Escreva em português brasileiro.
* Use Markdown.
* Use linguagem clara, executiva e objetiva.
* Use IDs rastreáveis para requisitos, regras e critérios.
* Não confunda requisito funcional com regra de negócio.
* Não confunda critério de aceite com tarefa técnica.
* Não crie backlog técnico.
* Não escreva código.
* Não desenhe arquitetura.

## 4. Processo obrigatório antes de gerar qualquer saída

Antes de gerar o artefato, analise a demanda e identifique:

* Qual problema está sendo resolvido
* Quem é o usuário ou persona impactada
* Qual dor existe hoje
* Qual oportunidade de negócio existe
* Qual resultado esperado
* Qual contexto operacional, regulatório ou comercial existe
* Quais sistemas, áreas ou canais são impactados
* Quais dúvidas impedem um bom PRD
* Quais informações são fatos confirmados
* Quais informações são premissas
* Quais pontos são hipóteses
* Qual nível de confiança existe na demanda

Se houver informação suficiente, siga com premissas explícitas.

Se faltar informação crítica, use `[A confirmar]` ou gere perguntas objetivas, dependendo do modo.

## 5. Nível de confiança

Para cada seção crítica, indique o nível de confiança quando fizer sentido:

* Alto: informação fornecida explicitamente.
* Médio: inferência razoável baseada no contexto.
* Baixo: hipótese que precisa validação.

Não esconda incerteza.

Não complete lacunas como se fossem fatos.

## 6. Modo auto

Use quando o usuário apenas descreveu uma ideia, dor, demanda, épico ou feature.

Neste modo:

1. Classifique a demanda.
2. Avalie se há informação suficiente.
3. Escolha automaticamente entre:
   * Discovery Brief
   * PRD Lean
   * PRD Completo
4. Explique brevemente por que escolheu esse formato.
5. Gere o artefato mais adequado.

Critério de decisão:

* Use Discovery Brief quando faltar clareza sobre problema, público, evidência, métrica, regra de negócio ou impacto.
* Use PRD Lean quando a demanda for simples, de baixo risco, baixo impacto regulatório e escopo limitado.
* Use PRD Completo quando houver impacto relevante em negócio, cliente, operação, receita, compliance, múltiplos canais, múltiplas áreas, múltiplos sistemas ou risco significativo.

## 7. Modo discovery

Use quando a demanda ainda está vaga ou precisa de entendimento antes de virar PRD.

Gere a saída neste formato:

# Discovery Brief: <nome da iniciativa>

## 1. Demanda recebida

## 2. Problema aparente

## 3. Persona ou público impactado

## 4. Dor atual

## 5. Oportunidade de negócio

## 6. Resultado esperado

## 7. Evidências disponíveis

| Evidência | Fonte | O que indica | Impacto | Grau de confiança |
| --------- | ----- | ------------ | ------- | ----------------- |

## 8. Hipóteses

## 9. Premissas

### Fatos confirmados

### Premissas

### Hipóteses

## 10. Lacunas de informação

| Lacuna | Por que importa | Como validar | Responsável provável |
| ------ | --------------- | ------------ | -------------------- |

## 11. Perguntas bloqueantes

## 12. Perguntas importantes

## 13. Perguntas desejáveis

## 14. Riscos de avançar sem discovery

Para cada risco, informe:

* risco
* impacto
* probabilidade
* mitigação
* plano de contingência

## 15. Próximos passos recomendados

Não gere PRD completo neste modo.

O objetivo é preparar a descoberta.

## 8. Modo lean

Use para demandas simples, features pequenas, melhorias de produto, MVPs iniciais ou iniciativas de baixo risco.

Gere a saída neste formato:

# PRD Lean: <nome da iniciativa>

## 1. Resumo executivo

Explique em poucas linhas o que será criado, para quem, por que isso importa e qual resultado se espera.

## 2. Problema de negócio

Use o formato:

Atualmente, <persona/área/sistema> enfrenta <problema>, causando <impacto>. Precisamos resolver isso para alcançar <resultado esperado>.

## 3. Outcome esperado

Inclua:

* resultado de negócio esperado
* comportamento do usuário que precisa mudar
* comportamento operacional que precisa mudar
* métrica que comprova a mudança
* prazo ou janela de observação

## 4. Objetivos do produto

Liste objetivos claros, mensuráveis e orientados a resultado.

Cada objetivo deve responder:

* O que queremos melhorar?
* Para quem?
* Como saberemos que deu certo?

## 5. Não objetivos

Liste explicitamente o que está fora do escopo.

## 6. Personas e stakeholders

Para cada persona ou stakeholder, descreva:

* interesse
* dor
* expectativa
* impacto da mudança

## 7. Jornada atual

Inclua:

* passos atuais
* canais envolvidos
* pontos de fricção
* exceções comuns
* impactos negativos
* dependência manual, se existir

## 8. Jornada proposta

Inclua:

* novo fluxo esperado
* entradas
* saídas
* decisões de negócio
* exceções
* mensagens ou comunicações ao usuário
* impacto operacional

## 9. Escopo da primeira versão

Inclua:

* o que entra
* o que fica para depois
* por que esse recorte faz sentido
* valor entregue na primeira versão
* risco de lançar somente esse recorte

## 10. Requisitos de negócio

Use IDs RN-001, RN-002, RN-003.

Para cada requisito:

### RN-001 — <nome do requisito>

Descrição:
<o que precisa acontecer do ponto de vista do negócio>

Regra: <regra objetiva>

Motivação:
<por que isso é necessário>

Critério de aceite:
<como validar que está correto>

Exceções:
<cenários alternativos ou impeditivos>

Nível de confiança:
<alto, médio ou baixo>

## 11. Requisitos funcionais

Use IDs RF-001, RF-002, RF-003.

Cada requisito funcional deve conter:

* ação do usuário ou sistema
* condição
* resultado esperado
* regras aplicáveis
* mensagens ou estados relevantes
* exceções
* nível de confiança

## 12. Critérios de aceite BDD

Use:

Dado <contexto>
Quando <ação>
Então <resultado esperado>

Cubra:

* cenário feliz
* erro de validação
* ausência de dados
* permissão negada
* indisponibilidade de dependência
* cancelamento ou reversão, se aplicável
* auditoria ou registro, se aplicável

## 13. Métricas de sucesso

Inclua:

* métrica principal
* métricas secundárias
* baseline atual, se conhecido
* meta esperada
* período de medição
* fonte dos dados

## 14. Dependências

Classifique como:

* bloqueante
* importante
* desejável

## 15. Riscos

Para cada risco, informe:

* risco
* impacto
* probabilidade
* mitigação
* plano de contingência

## 16. Premissas

### Fatos confirmados

### Premissas

### Hipóteses

## 17. Perguntas abertas

| Pergunta | Classificação | Por que importa | Responsável provável |
| -------- | ------------- | --------------- | -------------------- |

Classificação:

* bloqueante
* importante
* desejável

## 18. Definition of Ready

A demanda só estará pronta para engenharia quando:

* problema de negócio estiver claro
* personas estiverem definidas
* escopo e fora de escopo estiverem documentados
* regras de negócio estiverem numeradas
* critérios de aceite estiverem verificáveis
* dependências bloqueantes estiverem resolvidas
* métricas de sucesso estiverem definidas
* riscos principais tiverem mitigação
* perguntas bloqueantes estiverem respondidas

## 19. Sugestão de salvamento

Sugira salvar em:

```text
docs/prd/<nome-da-iniciativa>.md
```

## 9. Modo completo

Use para iniciativas com impacto relevante em negócio, cliente, operação, receita, compliance, múltiplas áreas, múltiplos canais, múltiplos sistemas, parceiros externos ou risco alto.

Gere a saída neste formato:

# PRD: <nome da iniciativa>

## 1. Resumo executivo

Explique em poucas linhas o que será criado, para quem, por que isso importa e qual resultado se espera.

## 2. Contexto

Descreva o cenário atual, a origem da demanda e o problema observado.

Inclua:

* situação atual
* dor principal
* impacto para usuário, operação ou negócio
* evidências disponíveis
* áreas ou canais envolvidos

## 3. Classificação da demanda

Classifique a demanda como uma ou mais opções:

* Ideia inicial
* Dor ou problema observado
* Oportunidade de negócio
* Demanda regulatória
* Feature já solicitada
* Épico de produto
* Melhoria operacional
* Experimento
* Requisito de parceiro/fornecedor

Explique a classificação.

## 4. Evidências e sinais da demanda

| Evidência | Fonte | O que indica | Impacto | Grau de confiança |
| --------- | ----- | ------------ | ------- | ----------------- |

Se não houver evidência suficiente, use `[A confirmar]`.

## 5. Problema de negócio

Use o formato:

Atualmente, <persona/área/sistema> enfrenta <problema>, causando <impacto>. Precisamos resolver isso para alcançar <resultado esperado>.

## 6. Outcome esperado

Inclua:

* resultado de negócio esperado
* comportamento do usuário que precisa mudar
* comportamento operacional que precisa mudar
* métrica que comprova a mudança
* prazo ou janela de observação

## 7. Objetivos do produto

Liste objetivos claros, mensuráveis e orientados a resultado.

Cada objetivo deve responder:

* O que queremos melhorar?
* Para quem?
* Como saberemos que deu certo?

## 8. Não objetivos

Liste explicitamente o que está fora do escopo.

## 9. Personas e stakeholders

Liste:

* usuários finais
* usuários internos
* áreas de negócio
* operação
* atendimento
* jurídico/compliance, se aplicável
* engenharia
* analytics/dados
* parceiros externos, se houver

Para cada um, descreva:

* interesse
* dor
* expectativa
* impacto da mudança

## 10. Jornada atual

Descreva como o processo funciona hoje.

Inclua:

* passos atuais
* canais envolvidos
* pontos de fricção
* exceções comuns
* impactos negativos
* dependência manual, se existir

## 11. Jornada proposta

Descreva como o processo deverá funcionar após a entrega.

Inclua:

* novo fluxo esperado
* entradas
* saídas
* decisões de negócio
* exceções
* mensagens ou comunicações ao usuário
* impacto operacional

## 12. Decisões de produto

| Decisão | Motivo | Alternativas consideradas | Trade-off | Dono provável | Status |
| ------- | ------ | ------------------------- | --------- | ------------- | ------ |

Status possíveis:

* tomada
* proposta
* pendente

## 13. Priorização

Classifique as capacidades usando:

* Must have
* Should have
* Could have
* Won't have agora

Para cada item, informe:

* valor de negócio
* urgência
* risco de não fazer
* complexidade percebida
* dependência
* justificativa

## 14. Requisitos de negócio

Use IDs RN-001, RN-002, RN-003.

Para cada requisito:

### RN-001 — <nome do requisito>

Descrição:
<o que precisa acontecer do ponto de vista do negócio>

Regra: <regra objetiva>

Motivação:
<por que isso é necessário>

Critério de aceite:
<como validar que está correto>

Exceções:
<cenários alternativos ou impeditivos>

Nível de confiança:
<alto, médio ou baixo>

## 15. Requisitos funcionais

Use IDs RF-001, RF-002, RF-003.

Cada requisito funcional deve conter:

* ação do usuário ou sistema
* condição
* resultado esperado
* regras aplicáveis
* mensagens ou estados relevantes
* exceções
* nível de confiança

## 16. Requisitos não funcionais de produto

Inclua apenas NFRs relevantes para a experiência e operação do produto.

Considere:

* disponibilidade esperada
* tempo de resposta esperado
* acessibilidade
* usabilidade
* rastreabilidade
* auditabilidade
* segurança do usuário
* privacidade/LGPD
* retenção de dados
* suporte operacional
* volumetria esperada
* impacto em atendimento

Não transforme esta seção em desenho técnico.

## 17. Dados necessários

| Dado | Origem | Uso | Obrigatório? | Sensibilidade | Validação | Retenção | Nível de confiança |
| ---- | ------ | --- | ------------ | ------------- | --------- | -------- | ------------------ |

Para cada dado, informe:

* nome conceitual
* origem
* uso
* obrigatoriedade
* sensibilidade
* regra de validação
* retenção, se aplicável
* nível de confiança

## 18. Regras de negócio detalhadas

Use IDs RB-001, RB-002, RB-003.

Cada regra deve ser escrita de forma objetiva, verificável e sem ambiguidade.

Exemplo:

RB-001: O cliente só poderá avançar se possuir cadastro ativo.
RB-002: Caso o cadastro esteja pendente, o sistema deve bloquear a solicitação e orientar regularização.
RB-003: A solicitação deve permanecer disponível para consulta por 90 dias.

## 19. User stories

Crie user stories no formato:

Como <persona>,
quero <ação/capacidade>,
para <benefício/resultado>.

Para cada user story, inclua:

* prioridade
* valor de negócio
* dependências
* critérios de aceite

## 20. Critérios de aceite

Use formato BDD:

Dado <contexto>
Quando <ação>
Então <resultado esperado>

Os critérios devem cobrir:

* cenário feliz
* erro de validação
* ausência de dados
* permissão negada
* indisponibilidade de dependência
* cancelamento ou reversão, se aplicável
* auditoria ou registro, se aplicável

## 21. Métricas de sucesso

Inclua:

* métrica principal
* métricas secundárias
* baseline atual, se conhecido
* meta esperada
* período de medição
* fonte dos dados

Exemplos:

* redução de tempo médio de atendimento
* aumento de conversão
* redução de abandono
* redução de chamados
* redução de erro operacional
* aumento de autosserviço
* redução de retrabalho

## 22. Dependências

Liste dependências de:

* áreas de negócio
* jurídico/compliance
* design/UX
* engenharia
* dados/analytics
* sistemas internos
* parceiros externos
* fornecedores
* aprovações
* campanhas ou comunicação

Classifique como:

* bloqueante
* importante
* desejável

## 23. Riscos de produto e negócio

Para cada risco, informe:

* risco
* impacto
* probabilidade
* mitigação
* plano de contingência

Considere riscos como:

* baixa adoção
* entendimento incorreto do usuário
* impacto operacional
* aumento de chamados
* regra regulatória mal interpretada
* dependência externa
* inconsistência de dados
* conflito com processo atual

## 24. Premissas

### Fatos confirmados

### Premissas

### Hipóteses

## 25. Perguntas abertas

| Pergunta | Classificação | Por que importa | Responsável provável |
| -------- | ------------- | --------------- | -------------------- |

Classificação:

* bloqueante
* importante
* desejável

## 26. Escopo da primeira versão

Defina o MVP ou primeira entrega.

Inclua:

* o que entra
* o que fica para depois
* por que esse recorte faz sentido
* valor entregue na primeira versão
* risco de lançar somente esse recorte

## 27. Plano de validação

Inclua:

* revisão com negócio
* revisão com UX
* revisão com engenharia
* revisão com jurídico/compliance, se aplicável
* validação com usuários, se aplicável
* protótipo, se necessário
* critérios para considerar o PRD aprovado

## 28. Definition of Ready

A demanda só estará pronta para engenharia quando:

* problema de negócio estiver claro
* personas estiverem definidas
* escopo e fora de escopo estiverem documentados
* regras de negócio estiverem numeradas
* critérios de aceite estiverem verificáveis
* dependências bloqueantes estiverem resolvidas
* métricas de sucesso estiverem definidas
* riscos principais tiverem mitigação
* perguntas bloqueantes estiverem respondidas

## 29. Checklist de qualidade do PRD

| Critério | Status | Observação |
| -------- | ------ | ---------- |

Critérios:

* O problema está claro antes da solução?
* Existe resultado de negócio esperado?
* As personas estão definidas?
* A jornada atual mostra a dor real?
* A jornada proposta resolve a dor sem pular regra de negócio?
* O escopo da primeira versão está justificado?
* Os não objetivos evitam interpretações erradas?
* Cada requisito de negócio é verificável?
* Cada requisito funcional tem condição, ação e resultado esperado?
* As regras de negócio estão numeradas e sem ambiguidade?
* Os critérios de aceite cobrem cenário feliz e exceções?
* As métricas têm baseline, meta, período e fonte?
* As dependências bloqueantes estão explícitas?
* Os riscos têm mitigação e contingência?
* As premissas estão separadas de fatos confirmados?
* As perguntas bloqueantes impedem ou não a engenharia de começar?
* O documento evita solução técnica prematura?
* O PRD está pronto para negócio, UX, engenharia e QA revisarem?

Status possíveis:

* OK
* Parcial
* Ausente
* Crítico

## 30. Sugestão de salvamento

Sugira salvar em:

```text
docs/prd/<nome-da-iniciativa>.md
```

## 10. Modo review

Use para revisar um PRD existente.

Entrada esperada:

```text
review <caminho-do-arquivo>
```

Tarefas:

1. Leia o PRD informado.
2. Avalie qualidade, clareza, completude e riscos.
3. Não reescreva tudo automaticamente.
4. Aponte lacunas e sugestões objetivas.
5. Classifique a maturidade do PRD.

Saída esperada:

# Review do PRD: <nome>

## 1. Nota geral

Dê uma nota de 0 a 10.

## 2. Diagnóstico executivo

## 3. Pontos fortes

## 4. Lacunas críticas

## 5. Ambiguidades

## 6. Requisitos não verificáveis

## 7. Riscos não tratados

## 8. Métricas insuficientes

## 9. Perguntas bloqueantes

## 10. Sugestões de melhoria

## 11. Recomendação

Classifique como:

* Pronto para discovery
* Pronto para refinamento
* Pronto para engenharia
* Não pronto

## 12. Checklist

| Critério | Status | Observação |
| -------- | ------ | ---------- |

Status possíveis:

* OK
* Parcial
* Ausente
* Crítico

## 11. Modo mvp

Use para recortar a primeira versão de uma iniciativa.

Tarefas:

1. Identifique o problema principal.
2. Identifique o menor escopo que entrega valor real.
3. Separe Must, Should, Could e Won't.
4. Explique trade-offs.
5. Informe riscos de lançar somente o MVP.
6. Informe o que deve ficar para versões futuras.

Saída esperada:

# Recorte de MVP: <nome da iniciativa>

## 1. Problema principal

## 2. Resultado mínimo esperado

## 3. Usuário ou área mais impactada

## 4. Capacidades candidatas

## 5. Priorização MoSCoW

| Item | Classificação | Justificativa | Risco de não incluir |
| ---- | ------------- | ------------- | -------------------- |

## 6. Escopo recomendado para V1

## 7. Fora do MVP

## 8. Trade-offs

## 9. Valor entregue

## 10. Riscos do recorte

## 11. Métricas para validar o MVP

## 12. Recomendação final

## 12. Modo perguntas

Use quando o objetivo for apenas descobrir o que perguntar antes de criar o PRD.

Saída esperada:

# Perguntas de discovery: <nome da iniciativa>

## 1. Perguntas bloqueantes

## 2. Perguntas importantes

## 3. Perguntas desejáveis

## 4. Perguntas por área

Inclua:

* negócio
* produto
* UX
* operação
* atendimento
* jurídico/compliance
* dados/analytics
* engenharia
* QA

## 5. Roteiro sugerido de discovery

Organize as perguntas em uma ordem lógica para uma reunião.

## 13. Modo salvar

Use quando o usuário pedir explicitamente para gerar e salvar o PRD.

Tarefas:

1. Gere o PRD no modo adequado.
2. Crie a pasta `docs/prd` se ela não existir.
3. Salve o arquivo em Markdown.
4. Use nome de arquivo em kebab-case.
5. Adicione ou atualize os metadados do PRD.
6. Atualize `docs/prd/README.md` com referência ao PRD.
7. Atualize `CLAUDE.md` com referência ao PRD.
8. Atualize `AGENTS.md` com referência ao PRD.
9. Informe o caminho final do arquivo.

Caminho padrão:

```text
docs/prd/<nome-da-iniciativa>.md
```

Referência mínima a adicionar em `docs/prd/README.md`:

```md
| PRD | Status | Descrição | Arquivo |
|---|---|---|---|
| <nome da iniciativa> | draft | <descrição curta> | docs/prd/<nome-da-iniciativa>.md |
```

Referência mínima a adicionar em `CLAUDE.md` e `AGENTS.md`:

```md
- PRD `<nome da iniciativa>`: `docs/prd/<nome-da-iniciativa>.md`
```

## 14. Modo referenciar

Use quando já existir um PRD e o usuário pedir para referenciar nos arquivos de agente.

Entrada esperada:

```text
referenciar docs/prd/<nome-da-iniciativa>.md
```

Tarefas:

1. Ler o PRD informado.
2. Identificar título, status, resumo e PRD ID.
3. Atualizar `docs/prd/README.md`.
4. Atualizar `CLAUDE.md`.
5. Atualizar `AGENTS.md`.
6. Não alterar o conteúdo do PRD, exceto se faltar frontmatter mínimo.
7. Se faltar frontmatter mínimo, adicionar sem apagar conteúdo existente.

## 15. Modo pre-sdd

Use quando o usuário quiser iniciar uma nova spec ou SDD a partir de uma demanda.

Entrada esperada:

```text
pre-sdd docs/prd/<nome-da-iniciativa>.md
```

Tarefas:

1. Ler obrigatoriamente o PRD informado.
2. Verificar se o PRD possui:
   * problema de negócio
   * objetivo do produto
   * escopo
   * fora de escopo
   * personas
   * requisitos de negócio
   * requisitos funcionais
   * regras de negócio
   * critérios de aceite
   * métricas de sucesso
   * dependências
   * riscos
   * perguntas abertas
3. Identificar perguntas bloqueantes.
4. Avaliar se o PRD está pronto para originar o planejamento da entrega (OpenSpec change).
5. Não criar a change automaticamente, a menos que o usuário peça explicitamente.
6. Se estiver pronto, recomendar o próximo passo: criar uma **OpenSpec change** via a skill
   `openspec-propose` ou `/opsx propose`, referenciando o PRD. O design/plano técnico (SDD)
   fica no `design.md` da change; o OpenSpec lê o PRD via `openspec/config.yaml`.
7. A change (proposal/design/tasks) deve conter referência explícita ao PRD de origem.

Saída esperada:

# Pré-validação para SDD: <nome da iniciativa>

## 1. PRD de origem

## 2. Status do PRD

## 3. Checklist de prontidão

| Critério | Status | Observação |
| -------- | ------ | ---------- |

## 4. Perguntas bloqueantes

## 5. Riscos de criar SDD agora

## 6. Recomendação

Classifique como:

* Pode iniciar SDD
* Pode iniciar SDD com ressalvas
* Não iniciar SDD ainda

## 7. Próximo passo recomendado

```text
/opsx propose <nome-da-iniciativa>   # cria a OpenSpec change que lê o PRD como base
```

A change fica em `openspec/changes/<nome-da-iniciativa>/` (proposal/design/tasks).

## 16. Regras de escrita

* Use Markdown limpo.
* Use títulos hierárquicos.
* Use tabelas apenas quando aumentarem clareza.
* Use IDs rastreáveis para requisitos e regras.
* Não confunda requisito funcional com regra de negócio.
* Não confunda critério de aceite com tarefa técnica.
* Não crie backlog técnico.
* Não escreva código.
* Não desenhe arquitetura.
* Não detalhe banco de dados, filas, APIs ou serviços, exceto quando forem restrições explícitas de produto, negócio, compliance ou operação.
* Escreva para produto, negócio, UX, engenharia e QA.
* Evite jargão técnico desnecessário.
* Seja objetivo, mas completo.

## 17. Saída final obrigatória

A saída final deve conter:

* artefato gerado no modo correto
* decisões ou recomendações
* premissas
* perguntas abertas
* riscos
* critérios de aceite, quando aplicável
* sugestão de caminho de salvamento
* referência ao PRD de origem, quando o próximo passo for a OpenSpec change

Caminho sugerido para PRD:

```text
docs/prd/<nome-da-iniciativa>.md
```

Próximo passo (planejamento da entrega) — OpenSpec change:

```text
/opsx propose <nome-da-iniciativa>   # cria openspec/changes/<nome-da-iniciativa>/ (proposal/design/tasks)
```

Se o usuário pediu para salvar, salve o arquivo.

Se o usuário não pediu para salvar, apenas sugira o caminho.

## 18. Resumo operacional

Resumo de bolso (referência rápida; o detalhamento está nas seções acima).

### Quando usar

Quando o usuário pedir PRD, requisitos de produto, discovery de demanda, recorte de MVP,
revisão de PRD, perguntas de refinamento, ou validar a prontidão de um PRD antes de uma
spec/SDD. Toda demanda de produto deve começar por um PRD.

### Quando NÃO usar

Para criar código de aplicação, desenhar arquitetura, escrever a OpenSpec change/design em si
ou gerar backlog técnico. O planejamento da entrega é uma OpenSpec change derivada do PRD
(ver modo `pre-sdd` + `/opsx propose`), nunca o contrário.

### Inputs

Modo (opcional; padrão `auto`) + descrição da demanda (ideia, dor, oportunidade, épico
ou feature) ou um caminho de PRD existente (ex.: `review docs/prd/<arquivo>.md`,
`referenciar docs/prd/<arquivo>.md`, `pre-sdd docs/prd/<arquivo>.md`).

### Workflow

1. Analise a demanda (seção 4) e classifique fatos, premissas e hipóteses.
2. Selecione o modo (seção 2) — em `auto`, escolha entre Discovery Brief, PRD Lean ou PRD Completo.
3. Gere o artefato no formato do modo, com IDs rastreáveis, riscos e critérios de aceite.
4. No modo `salvar`: persista em `docs/prd/<nome-da-iniciativa>.md`, adicione o frontmatter
   e referencie em `docs/prd/README.md`, `CLAUDE.md` e `AGENTS.md`.
5. No modo `pre-sdd`: leia o PRD, valide prontidão e recomende criar a OpenSpec change (`/opsx propose`).

### Comandos

```bash
ls docs/prd/ 2>/dev/null || true
ls openspec/changes/ 2>/dev/null || true
```

### Saída esperada

Artefato do modo escolhido com premissas, perguntas abertas, riscos, critérios de aceite
(quando aplicável) e sugestão de caminho `docs/prd/<nome-da-iniciativa>.md`. O próximo passo
(planejamento) é uma OpenSpec change via `/opsx propose`, que referencia o PRD de origem.

### Nota de segurança

Não execute comandos destrutivos. Nunca exponha nem grave secrets, tokens, credenciais
ou dados sensíveis no PRD; para dados sensíveis use `[A confirmar]` e trate na seção de
privacidade/LGPD. Não invente números, métricas, regras regulatórias ou volumetria.
