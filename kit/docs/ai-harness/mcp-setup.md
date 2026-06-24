# MCP Setup: Claude Code, Codex CLI, DevContainer e Linux

Guia operacional para MCPs gratuitos neste harness. O padrão é mínimo privilégio:
MCP read-only no uso diário, MCP com escrita apenas em profile de laboratório.

Fontes oficiais:

- Context7: <https://github.com/upstash/context7>
- Spring Documentation MCP: <https://github.com/tky0065/springdocs-mcp>
- AWS MCP Servers: <https://awslabs.github.io/mcp/>
- Terraform MCP Server: <https://github.com/hashicorp/terraform-mcp-server>
- LocalStack MCP Server: <https://github.com/localstack/localstack-mcp-server>
- LocalStack announcement: <https://blog.localstack.cloud/introducing-localstack-mcp-server/>
- Claude Code MCP: <https://docs.anthropic.com/en/docs/claude-code/mcp>
- Codex MCP: <https://developers.openai.com/codex/mcp>

## Visao Geral Da Arquitetura

Perfis:

| Profile | Uso | MCPs |
|---|---|---|
| `safe-profile` | Dia a dia, leitura e documentacao | Context7, Springdocs, AWS Documentation, Terraform registry-only |
| `lab-aws-profile` | Laboratorio AWS sandbox | Tudo do safe-profile + AWS Pricing + SNS/SQS sandbox read-only |
| `lab-localstack-profile` | Laboratorio local com Docker Compose/LocalStack/Terraform | Tudo do safe-profile + LocalStack MCP |

Regras:

- Nunca usar credencial de producao.
- Nunca usar `AdministratorAccess`, `PowerUserAccess` ou politicas `*FullAccess`.
- Nao expor filesystem amplo para MCP.
- Nao habilitar Gmail, Calendar, banco real ou Kubernetes write agora.
- MCP com escrita fica fora do `safe-profile`.
- Secrets entram somente por variaveis de ambiente locais.
- Preferir versao fixada: `@localstack/localstack-mcp-server@0.5.0`, imagens Docker com tag explicita quando disponivel.

## Pre-requisitos

### Docker

```bash
docker version
docker ps
```

Se falhar com permissao:

```bash
sudo usermod -aG docker "$USER"
newgrp docker
docker ps
```

### Node, npm e npx

```bash
node --version
npm --version
npx --version
```

Requisito para LocalStack MCP: Node.js 20+.

### Python, uv e uvx

```bash
python3 --version
uv --version
uvx --version
```

Instalacao local sugerida:

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### AWS CLI Profile Sandbox

```bash
aws configure sso --profile sandbox
aws sts get-caller-identity --profile sandbox
```

Permissoes maximas recomendadas para o lab:

```text
AWSPriceListServiceReadOnly
AmazonSQSReadOnlyAccess
AmazonSNSReadOnlyAccess
```

Para testes mutaveis de SNS/SQS, crie policy customizada restrita por ARN, tag e
ambiente sandbox. Nao use `AmazonSQSFullAccess`, `AmazonSNSFullAccess`,
`PowerUserAccess` ou `AdministratorAccess`.

### LocalStack Token

O MCP oficial do LocalStack exige `LOCALSTACK_AUTH_TOKEN` para as tools. Configure
somente no shell local, 1Password, direnv privado ou secret manager do seu uso.
Se um token for colado em chat, log ou issue, revogue/rotacione antes de usar no
dia a dia.

```bash
export LOCALSTACK_AUTH_TOKEN="ls_xxx"
```

Validacoes:

```bash
npx -y @localstack/localstack-mcp-server@0.5.0 --help
docker ps
```

Este repo tambem versiona `.mcp.json` com o MCP `localstack-lab`, apontando para
`scripts/mcp/localstack.sh`. O wrapper exige `LOCALSTACK_AUTH_TOKEN` no ambiente
e nao grava o valor em arquivo.

### LocalStack Por Docker Compose Neste Projeto

Neste repo, o LocalStack deve ser iniciado pelo Docker Compose versionado, e a
infra local deve ser criada pelo Terraform em `infra/localstack/`.

```bash
cp .env.example .env
# edite .env e preencha LOCALSTACK_AUTH_TOKEN com um token rotacionado
docker compose up -d localstack
docker compose ps
curl -s http://localhost:4566/_localstack/health
```

Terraform local:

```bash
terraform -chdir=infra/localstack init
terraform -chdir=infra/localstack validate
terraform -chdir=infra/localstack plan
```

`terraform apply` e `terraform destroy` exigem decisao humana explicita. Agentes
nao devem rodar esses comandos automaticamente.

## Claude Code

### Listar, Inspecionar e Remover

```bash
claude mcp list
claude mcp get context7
claude mcp remove context7
```

Use `--scope user` para MCPs reutilizaveis entre projetos. Use `--scope project`
somente quando a configuracao deve ficar no repo em `.mcp.json`.

### safe-profile

```bash
claude mcp add --scope user context7 \
  -- bash scripts/mcp/context7.sh

claude mcp add --scope user springdocs \
  -- bash scripts/mcp/springdocs.sh

claude mcp add --scope user aws-docs \
  -e FASTMCP_LOG_LEVEL=ERROR \
  -- uvx awslabs.aws-documentation-mcp-server@latest

claude mcp add --scope user terraform-registry \
  -- docker run -i --rm \
  hashicorp/terraform-mcp-server:1.0.0 --toolsets=registry
```

### lab-aws-profile

```bash
claude mcp add --scope user aws-pricing-sandbox \
  -e AWS_PROFILE=sandbox \
  -e AWS_REGION=us-east-1 \
  -- uvx awslabs.aws-pricing-mcp-server@latest
```

### lab-localstack-profile

O LocalStack MCP nao entra no `safe-profile`: ele pode iniciar/parar containers,
fazer deploy/destroy de IaC local, ler logs e manipular estado local. Neste
projeto, prefira pedir ao MCP para observar/validar o LocalStack ja iniciado por
`docker compose`, nao para criar um container paralelo.

Instalacao via `npx`, mais simples:

```bash
claude mcp add --scope project localstack-lab \
  -- bash scripts/mcp/localstack.sh
```

Instalacao via Docker, mais isolada em dependencias, mas com risco maior por
montar Docker socket:

```bash
claude mcp add --scope user localstack-lab-docker \
  -e LOCALSTACK_AUTH_TOKEN="$LOCALSTACK_AUTH_TOKEN" \
  -e MCP_ANALYTICS_DISABLED=1 \
  -- docker run -i --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$PWD:$PWD" \
  -w "$PWD" \
  -e LOCALSTACK_AUTH_TOKEN \
  -e MCP_ANALYTICS_DISABLED \
  -e MAIN_CONTAINER_NAME=localstack-main \
  -e LOCALSTACK_HOSTNAME=host.docker.internal \
  --add-host host.docker.internal:host-gateway \
  localstack/localstack-mcp-server:latest
```

## Codex CLI

Codex carrega `~/.codex/config.toml` e profiles em
`~/.codex/<profile>.config.toml`. Execute com:

```bash
codex --profile safe-profile
codex --profile lab-aws-profile
codex --profile lab-localstack-profile
```

### `~/.codex/config.toml`

```toml
model_reasoning_effort = "high"
sandbox_mode = "workspace-write"
approval_policy = "on-request"
```

### `~/.codex/safe-profile.config.toml`

```toml
[mcp_servers.context7]
command = "bash"
args = ["scripts/mcp/context7.sh"]
startup_timeout_sec = 30
tool_timeout_sec = 120

[mcp_servers.springdocs]
command = "bash"
args = ["scripts/mcp/springdocs.sh"]
env = { NODE_OPTIONS = "--max-old-space-size=4096", REQUEST_TIMEOUT = "15000", MAX_RETRIES = "3" }
startup_timeout_sec = 30
tool_timeout_sec = 120

[mcp_servers.aws-docs]
command = "uvx"
args = ["awslabs.aws-documentation-mcp-server@latest"]
env = { FASTMCP_LOG_LEVEL = "ERROR" }

[mcp_servers.terraform-registry]
command = "docker"
args = ["run", "-i", "--rm", "hashicorp/terraform-mcp-server:1.0.0", "--toolsets=registry"]
```

### `~/.codex/lab-aws-profile.config.toml`

```toml
[mcp_servers.aws-pricing-sandbox]
command = "uvx"
args = ["awslabs.aws-pricing-mcp-server@latest"]
env = { AWS_PROFILE = "sandbox", AWS_REGION = "us-east-1" }
```

### `~/.codex/lab-localstack-profile.config.toml`

```toml
[mcp_servers.localstack-lab]
command = "bash"
args = ["scripts/mcp/localstack.sh"]
env = { MCP_ANALYTICS_DISABLED = "1", MAIN_CONTAINER_NAME = "localstack-main" }
env_vars = ["LOCALSTACK_AUTH_TOKEN"]
startup_timeout_sec = 30
tool_timeout_sec = 120
```

Alternativa via CLI para MCPs sem secrets persistentes:

```bash
codex mcp list
codex mcp get localstack-lab
codex mcp remove localstack-lab
```

Para LocalStack, prefira o arquivo TOML com `env_vars = ["LOCALSTACK_AUTH_TOKEN"]`
em vez de `codex mcp add --env LOCALSTACK_AUTH_TOKEN=...`, para nao persistir
o token em config.

## DevContainer Opcional

Nao grave tokens no `devcontainer.json`. Apenas propague variaveis existentes:

```json
{
  "containerEnv": {
    "AWS_PROFILE": "${localEnv:AWS_PROFILE}",
    "AWS_REGION": "${localEnv:AWS_REGION}",
    "LOCALSTACK_AUTH_TOKEN": "${localEnv:LOCALSTACK_AUTH_TOKEN}"
  },
  "mounts": [
    "source=${localEnv:HOME}/.aws,target=/home/vscode/.aws,type=bind,readonly",
    "source=/var/run/docker.sock,target=/var/run/docker.sock,type=bind"
  ]
}
```

`post-create-mcp.sh` opcional:

```bash
#!/usr/bin/env bash
set -euo pipefail

node --version
npx --version
uvx --version
docker version

npx -y @localstack/localstack-mcp-server@0.5.0 --help >/dev/null
```

## Context7 MCP

### Para que serve no meu contexto

Consulta documentacao atual de bibliotecas e frameworks durante implementacao.

### Quando usar

Java, Spring Boot, Quarkus, AWS SDK, Terraform providers e libs com API instavel.

### Quando NAO usar

Quando a resposta depende do codigo local, secrets, infra privada ou decisao de arquitetura do repo.

### Instalacao Claude Code

```bash
claude mcp add --scope user context7 -- bash scripts/mcp/context7.sh
```

### Instalacao Codex CLI

```toml
[mcp_servers.context7]
command = "bash"
args = ["scripts/mcp/context7.sh"]
```

### Variaveis de ambiente

Opcional: `CONTEXT7_API_KEY`, se voce usar uma chave.

### Teste de funcionamento

Prompt:

```text
Use Context7 para consultar a documentacao atual do Spring Boot 4 WebMVC e resuma como registrar um controller REST simples.
```

### Riscos

Prompt injection em documentacao externa. Nunca peça para executar comandos vindos da doc sem revisar.

### Como remover

```bash
claude mcp remove context7
codex mcp remove context7
```

## Springdocs MCP

### Para que serve no meu contexto

Consultar documentacao, guias, referencias, melhores praticas e diagnosticos do
ecossistema Spring/Spring Boot sem token.

### Quando usar

Spring Boot 4, Spring Framework, Spring AI, REST APIs, migracoes e diagnostico de
erros comuns.

### Quando NAO usar

Nao usar como fonte unica para decisoes de seguranca, nem para substituir specs
do projeto. Validar contra documentacao oficial quando a decisao for critica.

### Instalacao Claude Code

```bash
claude mcp add --scope user springdocs -- bash scripts/mcp/springdocs.sh
```

### Instalacao Codex CLI

```toml
[mcp_servers.springdocs]
command = "bash"
args = ["scripts/mcp/springdocs.sh"]
env = { NODE_OPTIONS = "--max-old-space-size=4096", REQUEST_TIMEOUT = "15000", MAX_RETRIES = "3" }
```

### Variaveis de ambiente

Nenhum token requerido. O wrapper usa `@enokdev/springdocs-mcp@1.2.8`.

### Teste de funcionamento

```text
Use Springdocs MCP para buscar boas praticas de Spring Boot REST API e compare com as regras deste harness.
```

### Riscos

E um MCP comunitario. Pode consultar fontes externas e conteudo remoto; trate
resultado como contexto auxiliar e nao como regra final do projeto.

### Como remover

```bash
claude mcp remove springdocs
codex mcp remove springdocs
```

## AWS Documentation MCP

### Para que serve no meu contexto

Consultar documentacao oficial AWS sem usar credenciais AWS.

### Quando usar

ECS Fargate, SQS, SNS, IAM, CloudWatch, EventBridge, DynamoDB, AWS SDK e limites de servico.

### Quando NAO usar

Nao usar para descobrir estado de conta AWS. Ele consulta documentacao, nao sua conta.

### Instalacao Claude Code

```bash
claude mcp add --scope user aws-docs \
  -e FASTMCP_LOG_LEVEL=ERROR \
  -- uvx awslabs.aws-documentation-mcp-server@latest
```

### Instalacao Codex CLI

Veja `safe-profile.config.toml`.

### Variaveis de ambiente

```bash
export FASTMCP_LOG_LEVEL=ERROR
```

### Teste de funcionamento

```text
Use AWS Documentation MCP para resumir as recomendacoes oficiais de retry e visibility timeout do SQS.
```

### Riscos

Documentacao pode ser extensa. Exija links e versoes quando a decisao for critica.

### Como remover

```bash
claude mcp remove aws-docs
codex mcp remove aws-docs
```

## Terraform MCP

### Para que serve no meu contexto

Consultar Registry, providers, modulos e recursos Terraform.

### Quando usar

Escrever ou revisar Terraform, especialmente AWS provider e modulos.

### Quando NAO usar

Nao habilitar operacoes Terraform (`plan/apply/destroy`) no `safe-profile`.

### Instalacao Claude Code

```bash
claude mcp add --scope user terraform-registry \
  -- docker run -i --rm \
  hashicorp/terraform-mcp-server:1.0.0 --toolsets=registry
```

### Instalacao Codex CLI

Veja `safe-profile.config.toml`.

### Variaveis de ambiente

Nenhuma para registry publico.

### Teste de funcionamento

```text
Use Terraform MCP para buscar a documentacao do recurso aws_sqs_queue e compare fifo_queue, visibility_timeout_seconds e redrive_policy.
```

### Riscos

Nao misturar consulta de Registry com aplicacao de IaC. `terraform apply` fica fora dos MCPs por enquanto.

### Como remover

```bash
claude mcp remove terraform-registry
codex mcp remove terraform-registry
```

## AWS Pricing MCP

### Para que serve no meu contexto

Consultar preco estimado de servicos AWS em sandbox/lab.

### Quando usar

Comparar ECS Fargate, SQS, SNS, NAT Gateway, DynamoDB e CloudWatch em design review.

### Quando NAO usar

Nao usar com profile de producao ou para billing real sem revisao humana.

### Instalacao Claude Code

```bash
claude mcp add --scope user aws-pricing-sandbox \
  -e AWS_PROFILE=sandbox \
  -e AWS_REGION=us-east-1 \
  -- uvx awslabs.aws-pricing-mcp-server@latest
```

### Instalacao Codex CLI

Veja `lab-aws-profile.config.toml`.

### Variaveis de ambiente

```bash
export AWS_PROFILE=sandbox
export AWS_REGION=us-east-1
```

### Teste de funcionamento

```text
Use AWS Pricing MCP com profile sandbox para estimar custo mensal de 2 tarefas ECS Fargate 0.5 vCPU/1GB em us-east-1.
```

### Riscos

Estimativa pode ficar errada se filtros de produto forem imprecisos. Validar manualmente antes de decisao financeira.

### Como remover

```bash
claude mcp remove aws-pricing-sandbox
codex mcp remove aws-pricing-sandbox
```

## LocalStack MCP

### Para que serve no meu contexto

Automatizar ciclo local cloud: iniciar LocalStack, verificar status, consultar docs
LocalStack, analisar logs, rodar `awslocal`, deployar Terraform/CDK/SAM local e
validar recursos em ambiente emulado.

O servidor oficial esta em preview experimental e o pacote atual do repositorio
declara versao `0.5.0`.

### Quando usar

- Desenvolvimento local AWS sem conta real.
- Teste de SQS/SNS/DynamoDB/S3/Lambda em LocalStack.
- Validacao de Terraform/CDK/SAM contra emulador.
- Diagnostico de logs e permissoes no ambiente local.

### Quando NAO usar

- `safe-profile` diario.
- Maquina sem Docker confiavel.
- Repo que nao deve ter acesso ao Docker socket.
- Qualquer fluxo que replique recursos de AWS real para LocalStack sem aprovacao.
- Chaos, Cloud Pods, App Inspector e recursos licenciados sem entender impacto/licenca.

### Instalacao Claude Code

```bash
export LOCALSTACK_AUTH_TOKEN="ls_xxx"

claude mcp add --scope user localstack-lab \
  -- bash scripts/mcp/localstack.sh

claude mcp list
claude mcp get localstack-lab
```

### Instalacao Codex CLI

Arquivo `~/.codex/lab-localstack-profile.config.toml`:

```toml
[mcp_servers.localstack-lab]
command = "bash"
args = ["scripts/mcp/localstack.sh"]
env = { MCP_ANALYTICS_DISABLED = "1", MAIN_CONTAINER_NAME = "localstack-main" }
env_vars = ["LOCALSTACK_AUTH_TOKEN"]
startup_timeout_sec = 30
tool_timeout_sec = 120
```

Uso:

```bash
export LOCALSTACK_AUTH_TOKEN="ls_xxx"
codex --profile lab-localstack-profile
```

### Variaveis de ambiente

```bash
export LOCALSTACK_AUTH_TOKEN="ls_xxx"
export MCP_ANALYTICS_DISABLED=1
export MAIN_CONTAINER_NAME=localstack-main
```

Evite expor `AWS_ACCESS_KEY_ID` e `AWS_SECRET_ACCESS_KEY` para esse MCP. O tool
de AWS Replicator le credenciais AWS da env; deixe isso desligado ate haver
um caso de uso claro e sandbox.

### Teste de funcionamento

Preflight local:

```bash
bash scripts/mcp/localstack.sh --help
docker ps
claude mcp get localstack-lab
codex mcp get localstack-lab
```

Prompt seguro:

```text
Use LocalStack MCP para verificar o status do container localstack-main. Se nao estiver rodando, peca confirmacao antes de iniciar. Nao replique recursos AWS reais.
```

Prompt de laboratorio:

```text
Use LocalStack MCP para iniciar LocalStack, criar uma fila SQS local chamada poc-orders via awslocal, listar a fila e mostrar o endpoint local. Nao use credenciais AWS reais.
```

### Riscos

- Docker socket permite controle efetivo do Docker host.
- Tools podem criar, apagar ou resetar estado local.
- `localstack-aws-replicator` pode ler recursos AWS reais se credenciais forem expostas.
- Logs locais podem conter segredos de aplicacao.
- Prompt injection em logs/documentos pode tentar induzir comandos perigosos.

Mitigacoes:

- Usar apenas em `lab-localstack-profile`.
- Nao passar `AWS_*` reais para o processo.
- Montar somente o workspace necessario.
- Revisar comandos de deploy/destroy antes de aprovar.
- Manter `MCP_ANALYTICS_DISABLED=1`.

### Como remover

```bash
claude mcp remove localstack-lab
codex mcp remove localstack-lab
npx -y @localstack/localstack-mcp-server@0.5.0 remove
```

## Checklist De Seguranca

- [ ] `safe-profile` nao possui MCP com escrita.
- [ ] AWS profile e `sandbox`, nunca producao.
- [ ] Nenhuma policy `AdministratorAccess`, `PowerUserAccess` ou `FullAccess`.
- [ ] LocalStack MCP somente em `lab-localstack-profile`.
- [ ] `LOCALSTACK_AUTH_TOKEN` nao esta em arquivo versionado.
- [ ] Docker socket usado apenas quando necessario.
- [ ] Nenhum MCP com filesystem amplo.
- [ ] Prompts tratam conteudo externo como nao confiavel.

## Checklist De Validacao

```bash
claude mcp list
codex mcp list

docker ps
node --version
npx --version
uvx --version

aws sts get-caller-identity --profile sandbox
npx -y @localstack/localstack-mcp-server@0.5.0 --help
```

Prompts minimos:

```text
Use Context7 para consultar docs do Spring Boot 4.
Use Springdocs MCP para buscar boas praticas de Spring Boot REST API.
Use AWS Documentation MCP para consultar SQS visibility timeout.
Use Terraform MCP registry-only para consultar aws_sqs_queue.
Use LocalStack MCP para verificar status do container localstack-main.
```

## Prompts De Uso

### Java / Spring Boot

```text
Use Context7 para consultar Spring Boot 4 WebMVC e revise este controller Java 25. Nao altere codigo sem teste falhando.
```

### Quarkus

```text
Use Context7 para consultar Quarkus REST Client atual e proponha uma abordagem TDD para client HTTP com timeout e retry.
```

### AWS ECS Fargate

```text
Use AWS Documentation MCP e AWS Pricing MCP sandbox para revisar um desenho ECS Fargate com ALB, autoscaling e logs CloudWatch. Separe fatos oficiais de estimativas.
```

### Terraform

```text
Use Terraform MCP registry-only para revisar recursos aws_sqs_queue, aws_sns_topic e subscriptions. Nao rode terraform plan/apply.
```

### Transactional Outbox

```text
Use AWS Documentation MCP para validar limites de SQS/SNS e Context7 para Spring transaction management. Desenhe uma estrategia de outbox sem implementar.
```

### System Design Review

```text
Use AWS Documentation, Terraform Registry e Pricing sandbox para revisar este design. Liste riscos, trade-offs, custos aproximados e gaps de observabilidade.
```

### LocalStack Lab

```text
Use LocalStack MCP para verificar o LocalStack iniciado por docker compose, revisar o Terraform em ./infra/localstack, validar recursos com awslocal e gerar um resumo. Peca confirmacao antes de terraform apply, destroy ou reset.
```

## Troubleshooting

### `uvx not found`

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
exec "$SHELL" -l
uvx --version
```

### `docker permission denied`

```bash
sudo usermod -aG docker "$USER"
newgrp docker
docker ps
```

### AWS profile nao encontrado

```bash
aws configure list-profiles
aws sts get-caller-identity --profile sandbox
```

### MCP nao aparece no Claude Code

```bash
claude mcp list
claude mcp get <nome>
```

Verifique escopo (`local`, `user`, `project`) e reinicie a sessao do Claude Code.

### Codex nao inicializa MCP

```bash
codex mcp list
codex mcp get <nome>
codex --profile lab-localstack-profile
```

Valide TOML e variaveis de ambiente.

### Timeout em servidor MCP

No Codex, aumente:

```toml
startup_timeout_sec = 30
tool_timeout_sec = 120
```

No Claude Code, verifique variaveis de timeout da sua versao e reduza latencia
preferindo Docker local ou cache de pacotes.

### LocalStack MCP pede token

```bash
test -n "${LOCALSTACK_AUTH_TOKEN:-}" && echo ok
claude mcp get localstack-lab
```

Se estiver usando DevContainer, propague `LOCALSTACK_AUTH_TOKEN` do host para o
container sem gravar o valor em arquivo.

### LocalStack MCP nao consegue controlar Docker

```bash
docker ps
localstack --version
```

Se usar variante Docker do MCP, confirme o mount do socket:

```text
-v /var/run/docker.sock:/var/run/docker.sock
```

## Recomendacao Objetiva

Instalar primeiro:

1. Context7
2. Springdocs MCP
3. AWS Documentation MCP
4. Terraform MCP registry-only

Instalar depois:

1. AWS Pricing MCP no `lab-aws-profile`
2. LocalStack MCP no `lab-localstack-profile`

Evitar por enquanto:

- Filesystem MCP amplo.
- Gmail/Calendar.
- Banco real.
- Kubernetes write.
- AWS Cloud Control CRUDL.
- Qualquer MCP comunitario sem pin de versao, origem clara e revisao.

Uso diario: `safe-profile`.

Labs AWS: `lab-aws-profile`.

Labs locais AWS/LocalStack: `lab-localstack-profile`.
