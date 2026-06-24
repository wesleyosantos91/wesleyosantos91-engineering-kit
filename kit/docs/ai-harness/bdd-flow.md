# BDD flow (quando aplicável)

Regra completa: `.ai/rules/bdd.md`. Comando de execução: `scripts/quality/test-bdd.sh`.

## Quando usar

Comportamento de negócio claro, fluxo de usuário, regra regulatória, regra de domínio
ou aceite funcional. Caso contrário, use teste unitário/integração.

## Estrutura

```text
src/test/resources/features/        # .feature (Gherkin)
src/test/java/<base-package>/bdd/    # steps + runner
```

## Habilitar (sem quebrar o build)

Não adicione Cucumber/JBehave/Spock automaticamente. Confirme a dependência primeiro:

```text
io.cucumber:cucumber-java
io.cucumber:cucumber-junit-platform-engine
org.junit.platform:junit-platform-suite
```

O `test-bdd.sh`:
- roda BDD se a dependência existir;
- avisa se há `features/` sem dependência;
- não falha se não houver BDD.

## Relação com TDD

BDD descreve o **comportamento de aceite**; TDD dirige a **implementação** unidade a
unidade. Os dois convivem: cenários BDD viram critérios, testes unitários garantem as partes.
