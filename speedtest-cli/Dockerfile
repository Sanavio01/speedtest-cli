ARG BUILD_FROM
FROM $BUILD_FROM

# Instalar dependências
RUN apk add --no-cache \
    python3 \
    py3-pip \
    curl \
    jq

# Instalar speedtest-cli
RUN apk add --no-cache python3 py3-pip curl jq py3-speedtest-cli

# Copiar arquivos do add-on
COPY run.sh /
RUN chmod a+x /run.sh

# Copiar arquivos web
COPY www /www


CMD [ "/run.sh" ]
