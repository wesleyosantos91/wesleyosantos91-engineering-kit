# Regra: Arquitetura

Arquitetura hexagonal/DDD pragmático com camadas explícitas. O **domínio é o centro**
e não conhece tecnologia.

SOLID é critério explícito de design para toda mudança de código produtivo.
Use `.ai/rules/solid.md` junto desta regra ao implementar ou revisar.

## Camadas e dependências permitidas

```
web ───────┐
message ───┤──► application ──► domain ◄── (ninguém de fora aponta para detalhes)
           │                        ▲
infrastructure ─────────────────────┘ (implementa interfaces do domain)
core (transversal, sem regra de negócio)
```

- `domain` **não** depende de Spring, JPA, AWS SDK, Kafka/SQS/SNS, HTTP client, web.
- `domain/repository` define **interfaces**; implementações ficam em `infrastructure`.
- `application` orquestra casos de uso (service/command/query); não acessa detalhe técnico direto.
- `web` é adapter de entrada HTTP/gRPC/GraphQL; `message` é adapter assíncrono.
- Controllers e listeners são **finos** (delegam para application).
- DTO de API **não** entra no domínio; Entity JPA **não** é Aggregate de domínio.
- `core` é transversal (annotation/validation/mapper/util) e **não** pode virar lixeira.

## Verificação

- Preferencial: ArchUnit (`scripts/quality/archunit.sh`).
- Fallback: `scripts/quality/package-rules.sh` (grep/find).

Detalhes em [`package-organization.md`](./package-organization.md) e
[`archunit.md`](./archunit.md). Critérios SOLID e riscos de design em
[`solid.md`](./solid.md).
