# ArchUnit — regras de arquitetura

ArchUnit valida a arquitetura como **teste JUnit 5**. Enquanto não estiver
configurado, o harness usa `scripts/quality/package-rules.sh` (grep/find) como
fallback equivalente.

## Dependência (test scope)

```xml
<dependency>
  <groupId>com.tngtech.archunit</groupId>
  <artifactId>archunit-junit5</artifactId>
  <version><!-- valide a versão estável --></version>
  <scope>test</scope>
</dependency>
```

## Local sugerido do teste

```text
src/test/java/<base-package>/architecture/ArchitectureTest.java
```

## Regras a implementar

```text
domain não depende de Spring          (org.springframework..)
domain não depende de JPA             (jakarta.persistence.. / javax.persistence..)
domain não depende de AWS SDK         (software.amazon.awssdk.. / com.amazonaws..)
domain não depende de Kafka/SQS/SNS   (org.apache.kafka.. / io.awspring..)
domain não depende de web             (..web..)
domain não depende de infrastructure  (..infrastructure..)
web não acessa JPA diretamente
message não acessa JPA diretamente
application não acessa detalhes técnicos diretamente
repositories técnicos ficam em infrastructure
controllers ficam em web
listeners ficam em message
DTOs de API não entram no domínio
```

## Esqueleto (referência — não cria regra de negócio)

```java
@AnalyzeClasses(packages = "<base-package>", importOptions = ImportOption.DoNotIncludeTests.class)
class ArchitectureTest {

  @ArchTest
  static final ArchRule domain_must_not_depend_on_frameworks =
      noClasses().that().resideInAPackage("..domain..")
          .should().dependOnClassesThat().resideInAnyPackage(
              "org.springframework..", "jakarta.persistence..", "javax.persistence..",
              "software.amazon.awssdk..", "com.amazonaws..",
              "org.apache.kafka..", "io.awspring..", "..web..", "..infrastructure..");

  @ArchTest
  static final ArchRule layered =
      layeredArchitecture().consideringAllDependencies()
          .layer("web").definedBy("..web..")
          .layer("message").definedBy("..message..")
          .layer("application").definedBy("..application..")
          .layer("domain").definedBy("..domain..")
          .layer("infrastructure").definedBy("..infrastructure..")
          .whereLayer("domain").mayOnlyBeAccessedByLayers("application", "infrastructure", "web", "message")
          .whereLayer("infrastructure").mayNotBeAccessedByLayers("domain");
}
```

Rodar: `bash scripts/quality/archunit.sh` (cai no fallback se ainda não houver ArchUnit).
