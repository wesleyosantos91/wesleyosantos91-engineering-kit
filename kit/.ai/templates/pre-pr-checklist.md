# Pré-PR checklist (GO / NO-GO)

- [ ] Diff revisado; escopo coeso (ver change-size-guidelines)
- [ ] OpenSpec validado; sem divergência spec×código
- [ ] TDD: teste antes da produção; bugfix com regressão
- [ ] `verify-all.sh --fast` (ou `--full`) verde
- [ ] JaCoCo >= 90% e PIT >= 90% (quando há código mensurável/mutável)
- [ ] ArchUnit/package-rules sem violações
- [ ] Sem secrets; sem comando destrutivo
- [ ] Contrato de API: sem breaking change sem versionamento (se aplicável)
- [ ] Documentação atualizada (se aplicável)

**Decisão:** GO / NO-GO — justificativa por item bloqueante.
