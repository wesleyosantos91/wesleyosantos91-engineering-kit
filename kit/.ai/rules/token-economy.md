# Regra: Economia de tokens / contexto

Contexto é recurso escasso. Use-o cirurgicamente.

## Princípios

- **Não** mande o repositório inteiro sem necessidade.
- Contexto **por tarefa**: só os arquivos relevantes ao que está sendo feito.
- Use **Repomix** quando precisar de panorama: `bash scripts/ai/context-pack.sh`
  (usa `repomix --compress`; fallback manual se ausente).
- Use **RTK** para comprimir saída de comandos (build/test/git) — já configurado.
- Preserve **headroom**: não encha a janela; deixe espaço para raciocínio.
- Em debug/review, use **modo conciso**; foque no trecho relevante.
- **Resuma logs grandes**, mas **preserve o stack trace relevante** por inteiro.
- **Não** comprima código a ponto de perder semântica.

## Ferramentas (opcionais — não instalar automaticamente)

```text
Repomix   # empacota contexto
RTK       # comprime saída de comandos
/compact  # compacta a conversa (Claude Code)
modo conciso
```

## Limites

- Não instalar ferramenta global automaticamente.
- Não vazar secrets ao empacotar contexto (ver [`security.md`](./security.md)).
