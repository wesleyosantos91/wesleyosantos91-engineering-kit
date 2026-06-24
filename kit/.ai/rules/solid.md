# Regra: SOLID e riscos de design

SOLID e critério explícito de design neste repositório. A regra vale para Codex,
Claude Code e qualquer agente que implemente ou revise código produtivo.

## Princípios

- **SRP — Single Responsibility Principle**: cada classe, método, componente ou
  pacote deve ter um motivo claro para mudar. Evite services que misturam regra
  de negócio, validação, persistência, integração externa e montagem de resposta.
- **OCP — Open/Closed Principle**: prefira extensão controlada a alteração
  arriscada de código estável. Use polimorfismo, composição ou estratégia quando
  houver variação real; não crie abstração prematura.
- **LSP — Liskov Substitution Principle**: implementações devem preservar o
  contrato do tipo base/interface. Não use subtipo que muda pré-condições,
  pós-condições, semântica de erro ou invariantes esperadas pelo chamador.
- **ISP — Interface Segregation Principle**: interfaces devem ser pequenas e
  orientadas ao consumidor. Não crie interfaces genéricas "manager", "helper" ou
  "service" com métodos não usados pelo consumidor.
- **DIP — Dependency Inversion Principle**: regras de negócio dependem de
  abstrações. Detalhes técnicos ficam fora do domínio e implementam portas em
  `infrastructure`.

## Riscos de design que bloqueiam implementação/review

- Regra de negócio em controller, listener, client, repository implementation ou
  entidade de persistência.
- `domain` dependendo de Spring, JPA, AWS, Kafka, HTTP, filesystem ou web.
- `application` acessando diretamente detalhe técnico que deveria ser porta.
- Service com múltiplas responsabilidades ou comportamento difícil de testar.
- Interface criada sem consumidor real ou só para espelhar uma única classe sem
  variação prevista.
- Herança usada onde composição resolveria com menor acoplamento.
- DTO de API, entity JPA ou modelo de mensageria vazando para domínio.
- Exceção técnica vazando para camada de domínio ou contrato público sem mapeamento.
- `core` acumulando utilitários soltos sem subdomínio claro.
- Abstração prematura que aumenta complexidade sem reduzir acoplamento real.

## Aplicação prática

- Comece pelo requisito/spec e teste falhando; o teste deve expor o contrato de
  comportamento esperado.
- Mantenha controllers/listeners finos e delegue casos de uso para `application`.
- Modele regra de negócio no `domain`; use ports/interfaces quando houver
  dependência externa.
- Coloque adapters, clients, persistência e frameworks em `infrastructure`.
- Prefira nomes de classes e métodos específicos ao domínio do problema.
- Ao revisar, cite o princípio violado e o risco concreto, com arquivo/linha.

## Relação com gates

SOLID não substitui ArchUnit, package-rules, JaCoCo ou PIT. Ele complementa os
gates: violações estruturais devem aparecer nos testes/arquitetura quando
possível; violações de design devem ser reportadas na review mesmo quando o
build está verde.

Referências relacionadas:

- `.ai/rules/architecture.md`
- `.ai/rules/package-organization.md`
- `.ai/rules/testing.md`
- `.ai/rules/tdd.md`
