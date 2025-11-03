# Add-on Speedtest CLI para Home Assistant

Este add-on permite executar testes de velocidade periodicamente no Home Assistant OS usando o speedtest-cli.

## Instalação

Existem duas formas de instalar: localmente ou via GitHub.

---

## Método 1: Instalação Local (Recomendado para teste)

### 1. Instalar File Editor

1. Vá em **Configurações** → **Add-ons** → **Loja de Add-ons**
2. Procure e instale **"File editor"** ou **"Studio Code Server"**
3. Inicie o add-on e abra a interface web

### 2. Criar a estrutura do add-on

No File Editor, crie a seguinte estrutura em `/addons/local/speedtest-cli/`:

```
/addons/local/speedtest-cli/
├── config.yaml
├── Dockerfile
├── build.yaml
├── run.sh
└── www/
    └── (pasta vazia)
```

**Importante:**

- Certifique-se de criar a pasta `local` dentro de `/addons/` se não existir
- Crie a pasta `www` (vazia)

### 3. Copiar os arquivos

Copie o conteúdo dos arquivos fornecidos para cada arquivo correspondente usando o File Editor.

### 4. Recarregar add-ons

1. Vá em **Configurações** → **Add-ons** → **Loja de Add-ons**
2. Clique nos 3 pontinhos (canto superior direito) → **Recarregar**
3. Na seção **"Local add-ons"** você verá o "Speedtest CLI"
4. Clique nele e depois em **Instalar**
5. Aguarde a compilação (pode levar alguns minutos)

---

## Método 2: Instalação via GitHub

### 1. Criar repositório no GitHub

Crie um novo repositório no GitHub com esta estrutura:

```
seu-repositorio/
├── repository.json
└── speedtest-cli/
    ├── config.yaml
    ├── Dockerfile
    ├── build.yaml
    ├── run.sh
    └── www/
        └── (vazio)
```

### 2. Criar arquivo repository.json na raiz

O arquivo `repository.json` deve estar na **raiz do repositório** (não dentro da pasta speedtest-cli):

```json
{
  "name": "Meus Add-ons para Home Assistant",
  "url": "https://github.com/SEU_USUARIO/SEU_REPOSITORIO",
  "maintainer": "Seu Nome"
}
```

### 3. Adicionar repositório no Home Assistant

1. Vá em **Configurações** → **Add-ons** → **Loja de Add-ons**
2. Clique nos 3 pontinhos (canto superior direito)
3. Selecione **Repositórios**
4. Adicione a URL: `https://github.com/SEU_USUARIO/SEU_REPOSITORIO`
5. Clique em **Adicionar**

### 4. Instalar o add-on

1. Atualize a loja de add-ons
2. Procure pelo seu repositório
3. Clique em "Speedtest CLI" e depois em **Instalar**

### 5. Configurar

Na aba **Configuration** do add-on, você pode definir:

```yaml
interval: 3600 # Intervalo entre testes (segundos)
server_id: null # ID do servidor (opcional)
```

### 6. Iniciar

1. Ative **"Start on boot"** se desejar
2. Clique em **Start**
3. Acesse a interface web através do botão **"OPEN WEB UI"**

## Uso

### Interface Web

O add-on possui uma interface web simples que mostra:

- Download (Mbps)
- Upload (Mbps)
- Ping (ms)
- Servidor usado
- Timestamp do último teste

A página atualiza automaticamente a cada 30 segundos.

### Resultados JSON

Os resultados são salvos em `/share/speedtest/`:

- `latest.json` - Último resultado
- `YYYYMMDD_HHMMSS.json` - Histórico de resultados

### Integrar com Home Assistant

Você pode criar sensores para ler os dados JSON:

```yaml
# configuration.yaml
sensor:
  - platform: command_line
    name: Speedtest Download
    command: "cat /share/speedtest/latest.json | jq '.download / 1000000 | round'"
    unit_of_measurement: "Mbps"
    scan_interval: 3600

  - platform: command_line
    name: Speedtest Upload
    command: "cat /share/speedtest/latest.json | jq '.upload / 1000000 | round'"
    unit_of_measurement: "Mbps"
    scan_interval: 3600

  - platform: command_line
    name: Speedtest Ping
    command: "cat /share/speedtest/latest.json | jq '.ping | round'"
    unit_of_measurement: "ms"
    scan_interval: 3600
```

## Opções Avançadas

### Escolher servidor específico

Para usar um servidor específico, primeiro liste os servidores disponíveis:

1. Entre no console do add-on (aba **Log**, depois **Open Terminal**)
2. Execute: `speedtest-cli --list | grep "Brazil"`
3. Anote o ID do servidor desejado
4. Configure na opção `server_id`

### Ajustar intervalo

O intervalo mínimo é 60 segundos e o máximo é 86400 segundos (24 horas).

**Recomendação:** Use intervalos maiores (1-4 horas) para evitar sobrecarga de rede e respeitar os servidores de teste.

## Troubleshooting

### Add-on não inicia

- Verifique os logs na aba **Log**
- Certifique-se de que o `run.sh` tem permissão de execução
- Verifique se todos os arquivos foram copiados corretamente

### Testes falhando

- Verifique sua conexão com a internet
- Tente um servidor diferente (use `server_id`)
- Aumente o intervalo entre testes

### Interface web não carrega

- Aguarde alguns segundos após o primeiro teste
- Verifique se a porta 8099 não está sendo usada por outro serviço
- Recarregue a página

## Suporte

Para problemas ou melhorias, verifique os logs do add-on na aba **Log**.
