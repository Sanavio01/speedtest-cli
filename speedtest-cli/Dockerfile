# Base padrão para addons do Home Assistant
ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base:3.19
FROM ${BUILD_FROM}

# Instalar dependências do sistema e speedtest-cli via pip
RUN apk add --no-cache python3 py3-pip curl jq \
 && pip install --no-cache-dir speedtest-cli

# Copiar arquivos do add-on
COPY run.sh /
RUN chmod a+x /run.sh

# Copiar arquivos web
COPY www /www

# Executar script principal
CMD [ "/run.sh" ]
