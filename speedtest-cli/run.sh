#!/usr/bin/with-contenv bashio

# Obter configurações
INTERVAL=$(bashio::config 'interval')
SERVER_ID=$(bashio::config 'server_id')

bashio::log.info "Iniciando Speedtest CLI Add-on"
bashio::log.info "Intervalo configurado: ${INTERVAL} segundos"

# Criar diretório para resultados
mkdir -p /share/speedtest

# Criar arquivo HTML inicial
cat > /www/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Speedtest Results</title>
    <meta http-equiv="refresh" content="30">
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background: #f5f5f5;
        }
        .result {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .metric {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #eee;
        }
        .metric:last-child {
            border-bottom: none;
        }
        .label {
            font-weight: bold;
        }
        h1 {
            color: #333;
        }
        .timestamp {
            color: #666;
            font-size: 0.9em;
        }
    </style>
</head>
<body>
    <h1>Speedtest Results</h1>
    <div id="results">
        <p>Aguardando primeiro teste...</p>
    </div>
</body>
</html>
EOF

# Função para executar speedtest e salvar resultados
run_speedtest() {
    bashio::log.info "Executando teste de velocidade..."
    
    # Montar comando
    CMD="speedtest-cli --json"
    if [ ! -z "$SERVER_ID" ]; then
        CMD="$CMD --server $SERVER_ID"
    fi
    
    # Executar teste
    RESULT=$($CMD 2>&1)
    
    if [ $? -eq 0 ]; then
        # Salvar resultado JSON
        echo "$RESULT" > /share/speedtest/latest.json
        echo "$RESULT" > "/share/speedtest/$(date +%Y%m%d_%H%M%S).json"
        
        # Extrair dados
        DOWNLOAD=$(echo "$RESULT" | jq -r '.download / 1000000 | round')
        UPLOAD=$(echo "$RESULT" | jq -r '.upload / 1000000 | round')
        PING=$(echo "$RESULT" | jq -r '.ping | round')
        SERVER=$(echo "$RESULT" | jq -r '.server.sponsor')
        TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
        
        bashio::log.info "Download: ${DOWNLOAD} Mbps | Upload: ${UPLOAD} Mbps | Ping: ${PING} ms"
        
        # Atualizar HTML
        cat > /www/index.html << EOF
<!DOCTYPE html>
<html>
<head>
    <title>Speedtest Results</title>
    <meta http-equiv="refresh" content="30">
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background: #f5f5f5;
        }
        .result {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .metric {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #eee;
        }
        .metric:last-child {
            border-bottom: none;
        }
        .label {
            font-weight: bold;
        }
        .value {
            font-size: 1.2em;
            color: #0066cc;
        }
        h1 {
            color: #333;
        }
        .timestamp {
            color: #666;
            font-size: 0.9em;
        }
    </style>
</head>
<body>
    <h1>Speedtest Results</h1>
    <div class="result">
        <p class="timestamp">Último teste: ${TIMESTAMP}</p>
        <div class="metric">
            <span class="label">Download:</span>
            <span class="value">${DOWNLOAD} Mbps</span>
        </div>
        <div class="metric">
            <span class="label">Upload:</span>
            <span class="value">${UPLOAD} Mbps</span>
        </div>
        <div class="metric">
            <span class="label">Ping:</span>
            <span class="value">${PING} ms</span>
        </div>
        <div class="metric">
            <span class="label">Servidor:</span>
            <span class="value">${SERVER}</span>
        </div>
    </div>
    <p style="color: #666; font-size: 0.9em;">Próximo teste em ${INTERVAL} segundos. Página atualiza automaticamente.</p>
</body>
</html>
EOF
    else
        bashio::log.error "Erro ao executar speedtest: $RESULT"
    fi
}

# Iniciar servidor web simples
cd /www
python3 -m http.server 8099 &

# Loop principal
while true; do
    run_speedtest
    sleep "$INTERVAL"
done