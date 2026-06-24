---
name: hello-kit
description: Skill de exemplo para validar criação de skill nova e sincronização via submódulo do engineering-kit. Use apenas como teste do fluxo.
---

# hello-kit

Skill mínima de exemplo para provar o fluxo de criação + sincronização do kit.

## Quando usar
- Para validar que uma skill nova é reconhecida após `git submodule update --remote`.

## Quando NÃO usar
- Em produção: é apenas um exemplo de teste.

## Inputs
- Nenhum.

## Workflow
1. inspect — confirma que a skill foi sincronizada.
2. report — informa que o fluxo funcionou.

## Comandos
```bash
bash scripts/ai/validate-skills.sh
```

## Saída esperada
- A skill `hello-kit` aparece como válida no `validate-skills.sh`.

## Segurança
- Não executa nada destrutivo; nunca expor secrets.
