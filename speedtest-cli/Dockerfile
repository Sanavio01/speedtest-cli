ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base:3.19
FROM ${BUILD_FROM}

# Instalar dependências
RUN apk add --no-cache python3 py3-pip curl jq \
 && pip install --no-cache-dir speedtest-cli

# Copiar arquivos do add-on
COPY run.sh /
RUN chmod a+x /run.sh

# Copiar arquivos web
COPY www /www

CMD [ "/run.sh" ]


