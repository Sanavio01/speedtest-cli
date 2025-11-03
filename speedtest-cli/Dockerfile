# Imagem base do Home Assistant para arquitetura Intel/AMD (amd64)
ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base:3.19
FROM ${BUILD_FROM}

# Instalar dependências e speedtest-cli
RUN apk add --no-cache python3 py3-pip curl jq py3-speedtest-cli

# Copiar script principal do add-on
COPY run.sh /run.sh
RUN chmod a+x /run.sh

# Copiar arquivos web (se existirem)
COPY www /www

# Executar o script
CMD [ "/run.sh" ]

