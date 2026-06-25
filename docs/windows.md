# Windows — symlinks

O `install.sh` depende de **symlinks** para a "fonte única" funcionar. No Windows há um
detalhe: o **Git Bash/MSYS** por padrão **copia** em vez de criar symlink — o que quebraria
o auto-sync (o conteúdo copiado não acompanharia o `submodule update`).

O `install.sh` força symlink nativo (`export MSYS=winsymlinks:nativestrict`) e **aborta com
erro** se a criação cair em cópia, em vez de quebrar silenciosamente.

## Opção recomendada — rodar dentro do DevContainer

O DevContainer é Linux: symlinks são nativos, sem nenhuma configuração. Abra o projeto no
container ("Reopen in Container") e rode o `bootstrap.sh` lá (ou deixe o `postCreate`
rodá-lo). **É o caminho mais simples.**

## Rodar no host Windows (Git Bash)

Para criar symlinks nativos no Windows você precisa de **um** destes:

1. **Developer Mode ligado** (recomendado):
   *Configurações → Privacidade e segurança → Para desenvolvedores → Modo de desenvolvedor → Ativado.*
   Permite criar symlinks sem privilégio de administrador.

2. **ou** rodar o Git Bash **como Administrador**.

E o Git precisa estar com symlinks habilitados:

```bash
git config --global core.symlinks true
```

> Ao instalar o Git for Windows, marque a opção **"Enable symbolic links"**. Se já estava
> instalado sem isso, o `core.symlinks true` acima resolve para novos checkouts.

### Verificar se está funcionando

```bash
export MSYS=winsymlinks:nativestrict
ln -s alvo teste_link && test -L teste_link && echo "OK: symlink nativo" || echo "FALHOU"
rm -f teste_link
```

Se aparecer `FALHOU` (ou um erro de privilégio), ligue o Developer Mode ou use o
DevContainer.

## Sintoma típico

Se o `install.sh` abortar com:

```
ERRO: '<arquivo>' não virou symlink (provável cópia do Git Bash sem Developer Mode).
```

→ ligue o Developer Mode (ou rode no DevContainer) e rode o `bootstrap.sh` de novo.

## Observação sobre clones

Ao clonar um projeto que já tem os symlinks commitados, o Git só os recria como symlinks
de verdade se `core.symlinks=true` e o ambiente permitir. Caso contrário, rode o
`bootstrap.sh` novamente após `git submodule update --init` para regenerá-los corretamente.
