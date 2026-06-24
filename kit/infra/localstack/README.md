# Terraform LocalStack

Terraform local para recursos AWS emulados no LocalStack deste projeto.

## Subir LocalStack

```bash
cp .env.example .env
# edite .env e preencha LOCALSTACK_AUTH_TOKEN
docker compose up -d localstack
docker compose ps
curl -s http://localhost:4566/_localstack/health
```

## Inicializar Terraform

```bash
terraform -chdir=infra/localstack init
terraform -chdir=infra/localstack validate
terraform -chdir=infra/localstack plan
```

## Aplicar Infra Local

`apply` e `destroy` sao permitidos somente por decisao humana explicita.

```bash
terraform -chdir=infra/localstack apply
terraform -chdir=infra/localstack destroy
```

## Regras

- Este diretório aponta para `http://localhost:4566`.
- Credenciais AWS sao dummy (`test/test`) para LocalStack.
- Nao use profile AWS real aqui.
- Nao coloque secrets em `*.tfvars` versionado.
- Recursos criados aqui devem ser pequenos, reproduziveis e removiveis.
