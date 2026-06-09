FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Atualiza pacotes base e instala dependências essenciais
RUN apt-get update && apt-get install -y \
    apache2 \
    bash \
    curl \
    procps \
    tar \
    gzip \
    net-tools \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Cria estrutura de diretórios do projeto dentro do container
RUN mkdir -p /app/hospital/pacientes \
             /app/hospital/consultas \
             /app/hospital/prontuarios \
             /app/hospital/exames \
             /app/hospital/internacoes \
             /app/hospital/logs \
             /app/hospital/backups \
    && mkdir -p /app/scripts \
    && mkdir -p /app/logs \
    && mkdir -p /app/backups

# Copia os scripts para dentro do container
COPY scripts/ /app/scripts/

# Copia o site estático para o Apache
COPY source/ /var/www/html/

# Dá permissão de execução em todos os scripts
RUN chmod +x /app/scripts/*.sh

# Expõe a porta 80 do Apache
EXPOSE 80

# Mantém container ativo em modo interativo
CMD ["bash"]
