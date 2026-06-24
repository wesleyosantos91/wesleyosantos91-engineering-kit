# Context strategy (economia de tokens)

Resumo operacional de `.ai/rules/token-economy.md`.

## Regras

- Contexto **cirúrgico por tarefa** — só os arquivos relevantes, não o repo inteiro.
- **Preserve headroom**: deixe espaço para raciocínio; use `/compact` (Claude) quando encher.
- **Resuma logs grandes**, mas mantenha o **stack trace relevante** inteiro.
- **Não comprima código** a ponto de perder semântica.
- Nunca inclua secrets no contexto.

## Ferramentas (opcionais, não instalar automaticamente)

| Ferramenta | Uso |
|---|---|
| Repomix | `bash scripts/ai/context-pack.sh` (usa `--compress`; fallback manual) |
| RTK | comprime saída de comandos (build/test/git) — já configurado |
| `/compact` | compacta a conversa no Claude Code |
| modo conciso | debug/review |

## Exclusões do context-pack

`target/`, `build/`, `.git/`, `.idea/`, `.vscode/`, `node_modules/`, binários, `.env`,
certificados (`*.pem`, `*.key`, `*.p12`, `*.jks`), logs grandes.

## Anti-padrões

- Mandar o repositório inteiro "por garantia".
- Colar logs gigantes sem resumir.
- Perder o stack trace ao resumir um erro.
