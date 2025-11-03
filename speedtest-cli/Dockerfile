# Base correta para seu mini PC Intel
ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base:3.19
FROM ${BUILD_FROM}

# Instalar dependências e bashio
RUN apk add --no-cache python3 py3-pip curl jq bash \
    && curl -sSL https://raw.githubusercontent.com/hassio-addons/bashio/main/install.sh | bash -s --

# Criar ambiente virtual Python e instalar speedtest-cli
RUN python3 -m venv /opt/venv && \
    . /opt/venv/bin/activate && \
    pip install --no-cache-dir speedtest-cli && \
    deactivate

ENV PATH="/opt/venv/bin:$PATH"

# Copiar arquivos do add-on
COPY run.sh /run.sh
RUN chmod a+x /run.sh
COPY www /www

# Comando padrão
CMD [ "/run.sh" ]
