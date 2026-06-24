# Regra: Checkstyle Java 25

Estilo padronizado via `config/checkstyle/checkstyle-java25.xml`
(+ `config/checkstyle/suppressions.xml`). Foco em legibilidade e manutenção —
**não** em Javadoc obrigatório em todo método.

## Checks principais

- Imports: `AvoidStarImport`, `UnusedImports`, `RedundantImport`, `IllegalImport`, `CustomImportOrder`.
- Complexidade: `MethodLength` (80), `ParameterNumber` (7), `CyclomaticComplexity` (12),
  `NPathComplexity` (200), `NestedIfDepth` (3), `ReturnCount` (5).
- Encapsulamento: `VisibilityModifier`, `FinalClass`, `HideUtilityClassConstructor`.
- Estrutura: `OneTopLevelClass`, `OuterTypeFilename`.
- Nomenclatura: `PackageName`, `TypeName`, `MemberName`, `MethodName`, `ConstantName`,
  `LocalVariableName`, `ParameterName`, `StaticVariableName`.
- Fluxo: `NeedBraces`, `FallThrough`, `MissingSwitchDefault`, `EqualsHashCode`.
- Espaçamento: `ModifierOrder`, `WhitespaceAround`, `NoWhitespaceBefore`, `ParenPad`, `OperatorWrap`.
- Arquivo: `NewlineAtEndOfFile`, `LineLength` (140), sem trailing whitespace, sem TAB.

## Comando

```bash
bash scripts/quality/checkstyle.sh
```

Se o `maven-checkstyle-plugin` não estiver no build, o script **valida a existência
da config e avisa** (não falha). Para habilitar, ver o bloco Checkstyle em
`config/pom-quality-plugins.example.xml`.

> Ajuste limites (LineLength, MethodLength) com pragmatismo ao adotar no time,
> mas mantenha imports e nomenclatura rígidos.
