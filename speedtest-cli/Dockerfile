# Base para sistemas x86_64 (Intel/AMD)
ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base:3.19
FROM ${BUILD_FROM}

# Instalar dependências do sistema
RUN apk add --no-cache python3 py3-pip curl jq

# Criar ambiente virtual e instalar o speedtest-cli dentro dele
RUN python3 -m venv /opt/venv && \
    . /opt/venv/bin/activate && \
    pip install --no-cache-dir speedtest-cli && \
    deactivate

# Adicionar o binário do venv ao PATH
ENV PATH="/opt/venv/bin:$PATH"

# Copiar script principal
COPY run.sh /run.sh
RUN chmod a+x /run.sh

# Copiar arquivos web (se houver)
COPY www /www

# Comando padrão do contêiner
CMD [ "/run.sh" ]
