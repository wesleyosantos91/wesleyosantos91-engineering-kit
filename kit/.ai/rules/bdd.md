# Regra: BDD (quando aplicável)

Use BDD quando houver **comportamento de negócio claro**, fluxo de usuário, regra
regulatória, regra de domínio ou aceite funcional. Não use BDD para detalhes
puramente técnicos (isso é teste unitário/integração).

## Estrutura

```text
src/test/resources/features/        # arquivos .feature (Gherkin)
src/test/java/<base-package>/bdd/    # step definitions / runners
```

## Frameworks possíveis

- Cucumber (`cucumber-java` + `cucumber-junit-platform-engine`)
- JBehave
- Spock (Groovy)

> **Não** adicione Cucumber/JBehave/Spock automaticamente. Confirme a dependência
> no build primeiro (pode quebrar o build). O harness só executa BDD se a
> dependência existir.

## Execução

```bash
bash scripts/quality/test-bdd.sh
```

- Se houver `features/` mas faltar dependência → o script **avisa**.
- Se não houver BDD → o script avisa e **não falha**.

## Exemplo de cenário (referência)

```gherkin
Funcionalidade: <regra de negócio>
  Cenário: <caso de aceite>
    Dado <pré-condição>
    Quando <ação do usuário>
    Então <resultado observável>
```
