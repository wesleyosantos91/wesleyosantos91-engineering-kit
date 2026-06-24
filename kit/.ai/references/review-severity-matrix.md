# Matriz de severidade de review

Use para classificar achados de forma consistente.

| Severidade | Critério | Ação |
|---|---|---|
| **CRÍTICO** | Quebra build/segurança/dados; viola isolamento do domínio; breaking change sem versionamento; secret exposto | **Bloqueia** (NO-GO) |
| **ALTO** | Gap de cobertura/mutação em domain/application; ausência de teste de regressão em bugfix; risco de resiliência relevante | Corrigir antes do merge |
| **MÉDIO** | Idiomatismo Java 25, legibilidade, duplicação, observabilidade incompleta | Corrigir ou registrar como follow-up |
| **BAIXO** | Estilo, nomenclatura, melhorias opcionais | Opcional |

Regra: separe sempre **críticos** (bloqueiam) de **melhorias** (não bloqueiam).
