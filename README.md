# Trabalho 03 - Linux, Shell Script e Cloud Computing

## Aluno
Marcuse Demarchi

## Tema
Hospital DC — Gerenciamento Hospitalar em Cloud Computing

## Descrição do Projeto

Este projeto simula o ambiente operacional de um hospital (Hospital DC) em infraestrutura cloud containerizada. Um profissional júnior de DevOps foi contratado para preparar o ambiente Linux, automatizar rotinas operacionais e publicar o portal institucional do hospital via Apache, tudo dentro de um container Docker com Ubuntu Server.

O cenário envolve: atualização do sistema, instalação de serviços, criação de estrutura de diretórios temática (pacientes, consultas, prontuários, exames, internações), backup automatizado, deploy do portal, monitoramento de recursos, gestão de usuários e permissões, e geração de relatórios operacionais.

---

## Tecnologias Utilizadas

- **Linux Ubuntu 22.04** (container Docker)
- **Docker** — containerização do ambiente
- **Docker Compose** — orquestração e volumes persistentes
- **Apache2** — servidor web para o portal do Hospital DC
- **Shell Script (Bash)** — automação de todas as rotinas
- **GitHub** — versionamento do projeto
- **DockerHub** — publicação da imagem

---

## Estrutura do Projeto

```
trabalho03-cloud-shell/
├── Dockerfile                   # Imagem Ubuntu + Apache
├── docker-compose.yml           # Orquestração com volumes
├── README.md                    # Este arquivo
├── scripts/
│   ├── 01_update.sh             # Atualização do sistema
│   ├── 02_apache.sh             # Instalação e validação do Apache
│   ├── 03_estrutura.sh          # Estrutura de diretórios temática
│   ├── 04_backup.sh             # Backup automatizado (.tar.gz)
│   ├── 05_deploy.sh             # Deploy do portal no Apache
│   ├── 06_processos.sh          # Gerenciamento de processos
│   ├── 07_monitoramento.sh      # Monitoramento CPU/RAM/Disco/Apache
│   ├── 08_usuarios_permissoes.sh# Usuários, grupos e permissões
│   ├── 09_relatorio.sh          # Relatório operacional automatizado
│   └── menu.sh                  # Menu principal interativo
├── source/
│   ├── index.html               # Portal principal do Hospital DC
│   ├── sobre.html               # Página sobre o hospital
│   └── assets/                  # Recursos estáticos
├── backups/                     # Backups gerados (volume persistente)
├── logs/                        # Logs gerados (volume persistente)
└── evidencias/                  # Prints e evidências de execução
```

---

## Como Executar

### Pré-requisitos
- Docker instalado: https://docs.docker.com/get-docker/
- Docker Compose instalado
- Git instalado

### 1. Clonar o repositório
```bash
git clone https://github.com/MarcuseDemarchi/HospitalDC.git
cd HospitalDC
```

### 2. Subir o container
```bash
docker compose up -d --build
```

### 3. Verificar se o container está rodando
```bash
docker ps
```

### 4. Entrar no container
```bash
docker exec -it trabalho03-linux bash
```

### 5. Navegar para a pasta de scripts
```bash
cd /app/scripts
```

### 6. Verificar permissões (já configuradas pelo Dockerfile)
```bash
ls -l *.sh
```

### 7. Executar o menu principal
```bash
./menu.sh
```

---

## Como Acessar o Portal no Navegador

Após subir o container, abra o navegador e acesse:

```
http://localhost:8080
```

O portal institucional do **Hospital DC** estará disponível com as páginas de Início e Sobre.

---

## Scripts Disponíveis

| Script | Descrição |
|---|---|
| `01_update.sh` | Atualiza os pacotes do sistema (apt update + upgrade) |
| `02_apache.sh` | Instala, inicia e valida o Apache2 |
| `03_estrutura.sh` | Cria diretórios temáticos do Hospital DC |
| `04_backup.sh` | Gera backup .tar.gz com data/hora no nome |
| `05_deploy.sh` | Publica os arquivos do portal no Apache |
| `06_processos.sh` | Lista, busca e encerra processos |
| `07_monitoramento.sh` | Monitora CPU, RAM, disco e status do Apache |
| `08_usuarios_permissoes.sh` | Cria grupos, usuários e aplica permissões |
| `09_relatorio.sh` | Gera relatório em logs/relatorio_execucao.txt |
| `menu.sh` | Menu principal interativo |

---

## Como Executar Cada Script Individualmente

Dentro do container (`docker exec -it trabalho03-linux bash`):

```bash
cd /app/scripts

# Atualizar sistema
./01_update.sh

# Instalar Apache
./02_apache.sh

# Criar estrutura de diretórios
./03_estrutura.sh

# Realizar backup
./04_backup.sh

# Fazer deploy do portal
./05_deploy.sh

# Gerenciar processos
./06_processos.sh listar
./06_processos.sh buscar apache2
./06_processos.sh matar 1234

# Monitorar sistema
./07_monitoramento.sh

# Configurar usuários e permissões
./08_usuarios_permissoes.sh

# Gerar relatório
./09_relatorio.sh
```

---

## Como Executar o Menu Principal

```bash
cd /app/scripts
./menu.sh
```

O menu interativo permite executar todas as rotinas via interface numerada (0 a 9).

---

## Evidências

As evidências de execução estão na pasta `evidencias/` do repositório:
- Container em execução
- Scripts com permissão de execução
- Saída de cada script
- Portal acessível no navegador
- Backup gerado
- Relatório operacional

---

## DockerHub

Imagem publicada em:
```
https://hub.docker.com/repository/docker/demarchi25/hospital-dc/general
```

Para usar diretamente sem build:
```bash
docker pull marcusedemarchi/hospital-dc:latest
```

---

## Uso de IA

Utilizei o Claude (Anthropic) como ferramenta de apoio para:
- Revisão da estrutura dos scripts Shell
- Sugestões de boas práticas em Bash (funções, validações, tratamento de erros)
- Apoio na organização do README

---

## Dificuldades Encontradas

- Adaptação do monitoramento de CPU no ambiente Docker (ausência de alguns utilitários)
- Configuração do serviço Apache em containers sem systemd (uso de `service` ao invés de `systemctl`)
- Garantir que os scripts funcionem tanto no host quanto dentro do container

---

*Trabalho 03 — Cloud Computing | Prof. Esp. Ademar Perfoll Junior | Sistemas de Informação | Unidavi | 2026*
