# Regra: Spotless (formatação)

Spotless é o formatter principal. Formatação **não é negociável em review** —
roda automático.

- Aplicar: `bash scripts/quality/format.sh`
- Validar: `bash scripts/quality/format-check.sh`

Cobre Java (Google/Palantir), imports, trailing whitespace, newline final, e
opcionalmente Markdown/YAML.

Quando não configurado, os scripts avisam (não falham). Habilitação e detalhes em
[`../../config/spotless/spotless-java25.md`](../../config/spotless/spotless-java25.md).

> Regra prática: rode `format.sh` **antes** do commit e `format-check.sh` é gate no
> `verify-all`.
