# Atualizar o kit (a "fonte única" na prática)

## Modelo mental

Um submódulo **aponta para um commit específico** do kit. Ele **não** segue o branch
automaticamente — você decide quando avançar o ponteiro. O que torna a propagação
barata é o **symlink**: assim que o submódulo aponta para um commit novo, os arquivos
symlinkados no seu projeto já refletem o novo conteúdo, **sem recopiar**.

```
kit (remoto, branch main)  ──update--remote-->  submódulo no commit novo
                                                      │  (symlinks já apontam pra cá)
seu projeto: .claude -> .engineering-kit/kit/.claude  ◄┘  conteúdo novo na hora
```

## Atualizar um projeto

```bash
# dentro do projeto consumidor
bash .engineering-kit/update.sh
git add .engineering-kit && git commit -m "chore: bump engineering-kit"
```

`update.sh` faz:
1. `git submodule update --remote --merge .engineering-kit` → traz o topo do branch
   rastreado (`main`).
2. Re-roda o `install.sh` (sem `--force`) → cria symlinks para **itens novos** que o kit
   passou a oferecer (ex.: uma skill nova). Arquivos já existentes não são tocados.

### Manualmente (equivalente)

```bash
git submodule update --remote --merge .engineering-kit
bash .engineering-kit/bootstrap.sh      # só pega itens novos; use --force p/ recriar tudo
git add .engineering-kit && git commit -m "chore: bump engineering-kit"
```

## Casos especiais

- **Conteúdo de um arquivo estável mudou** (ex.: um agent, um hook): nada a fazer além do
  `submodule update`. O symlink já entrega o novo conteúdo.
- **Arquivo NOVO num diretório já symlinkado** (ex.: `.claude/skills/nova-skill/`): como o
  diretório inteiro é um symlink, o arquivo novo aparece automaticamente. Sem ação.
- **Item de topo novo** (ex.: o kit passou a ter um diretório `.cursor/`): rode o
  `bootstrap.sh`/`update.sh` para criar o symlink novo.
- **Arquivo por-projeto mudou no kit** (ex.: novo placeholder em `CLAUDE.md`): como ele foi
  **copiado**, sua versão não muda sozinha. Compare com `kit/CLAUDE.md` e aplique à mão, ou
  rode `bootstrap.sh --force` para regenerar (perde suas edições locais).

## Fixar / reverter versão

```bash
# fixar num commit específico do kit
cd .engineering-kit && git checkout <sha> && cd ..
git add .engineering-kit && git commit -m "chore: pin engineering-kit em <sha>"
```

## Atualizar vários projetos de uma vez

Cada projeto é independente (aponta para o commit que você fixou). Para propagar uma
evolução do kit, rode o `update.sh` em cada projeto. Dá para automatizar com um loop ou
um job de CI que abre PRs de bump por repositório.
