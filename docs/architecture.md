# Arquitetura — symlink vs cópia

## Por que dois mecanismos

O kit é consumido como **submódulo** e a meta é **fonte única**: atualizar o kit propaga
para todos os projetos com um `git submodule update`. Isso só funciona se os configs forem
**referências** ao submódulo, não cópias.

Mas alguns arquivos precisam de **valores específicos do projeto** (nome, base package).
Esses não podem ser uma referência compartilhada — cada projeto tem o seu. Daí a divisão:

| Tipo | Mecanismo | Por quê | Atualiza com `submodule update`? |
|---|---|---|---|
| Config estável (skills, agents, commands, hooks, scripts, quality configs, devcontainer base) | **Symlink** → `.engineering-kit/kit/...` | Idêntico entre projetos | **Sim, automático** |
| Config por-projeto (placeholders `__BASE_PACKAGE__`/`__PROJECT_NAME__`) | **Cópia + substituição** | Valor é único de cada projeto e editável | Não (é seu; ver `updating.md`) |

## Entrypoint: `bootstrap.sh`

O `bootstrap.sh` (na raiz do submódulo) é o que você roda / o que o `postCreate` do
DevContainer chama. Ele orquestra:
1. `install.sh --target <raiz do projeto>` → cria os symlinks + scaffold (regra abaixo);
2. se estiver **dentro de um container**, `install-tools.sh` → instala toolchains/CLIs e
   inicia RTK (Claude + Codex), Caveman, OpenSpec, MCPs.

Fora do container, só o passo 1 roda (as ferramentas entram ao subir o DevContainer).

## Como o `install.sh` decide

Para cada item do payload (`kit/`), o script verifica se ele **contém** algum placeholder
(`grep` por `__BASE_PACKAGE__`/`__PROJECT_NAME__`):

- **Diretório sem nenhum placeholder** → 1 symlink para o diretório inteiro (mínimo de links).
- **Diretório com algum placeholder dentro** (ex.: `.devcontainer/`, `.ai/`, `config/`) →
  recria a árvore e decide **por arquivo**: o arquivo com placeholder é copiado+substituído;
  os demais viram symlink.
- **Arquivo solto** → symlink (estável) ou cópia+subst (placeholder).

Isso é detecção **dinâmica**: se um dia um arquivo ganhar/perder placeholder no kit, o
install passa a tratá-lo no modo certo sem mudar o script.

## Arquivos por-projeto hoje (copiados)

- `CLAUDE.md`, `AGENTS.md` — instruções dos agentes (base package, nome).
- `.ai/harness.yaml` — config do harness.
- `.devcontainer/devcontainer.json` — `"name"` do container.
- `config/pom-quality-plugins.example.xml` — exemplo com o base package nos filtros.

Todo o resto é symlink → **bebe da fonte**.

## Caminhos relativos

Os symlinks são **relativos** (ex.: `.claude -> .engineering-kit/kit/.claude`), então
continuam válidos em qualquer máquina/clone, independente do caminho absoluto do projeto.

## Layout do repositório

```
wesleyosantos91-engineering-kit/
├── bootstrap.sh                            # ENTRYPOINT: popula a raiz (+ instala tools no container)
├── install.sh / update.sh / uninstall.sh   # mecânica de symlink+scaffold
├── .gitattributes                          # força LF nos .sh (rodam no Linux)
├── LICENSE                                 # CC BY-SA 4.0
├── docs/                                   # esta documentação
└── kit/                                    # PAYLOAD (configs aplicadas ao projeto)
    ├── .claude/ .codex/ .agents/ .ai/ .devcontainer/
    ├── scripts/ config/ docs/ infra/ openspec/
    ├── .mcp.json compose.yaml CLAUDE.md AGENTS.md ...
    └── gitignore.kit                       # bloco aplicado ao .gitignore do projeto
```

## Limites conhecidos

- **Windows** exige Developer Mode para symlinks nativos (ver `windows.md`); o caminho
  recomendado é rodar o install dentro do DevContainer (Linux).
- Submódulo aponta para um **commit**, não para o topo do branch automaticamente —
  atualizar é um ato explícito (`update.sh`), o que é desejável para controle de versão.
