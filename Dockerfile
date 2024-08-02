# Usar a versão mais recente do Debian que o aprsc suporta
FROM debian:bullseye-slim

# Instalar dependências necessárias
RUN apt-get update && apt-get install -y gnupg wget

# Adicionar a chave de assinatura e a fonte do deb, instalar aprsc
RUN gpg --keyserver keyserver.ubuntu.com --recv-keys C51AA22389B5B74C3896EF3CA72A581E657A2B8D && \
    gpg --export C51AA22389B5B74C3896EF3CA72A581E657A2B8D > /etc/apt/trusted.gpg.d/aprsc.gpg && \
    echo "deb [signed-by=/etc/apt/trusted.gpg.d/aprsc.gpg] http://aprsc-dist.he.fi/aprsc/apt $(grep VERSION_CODENAME /etc/os-release | cut -d= -f2) main" > /etc/apt/sources.list.d/aprsc.list && \
    apt-get update && \
    apt-get install -y aprsc

# Mudar o UID do usuário aprsc para 1000
RUN usermod -u 1000 aprsc

# Copiar o arquivo de configuração para dentro do contêiner
COPY aprsc.conf /opt/aprsc/etc/aprsc.conf

# Iniciar o serviço e seguir os logs
CMD ["aprsc", "-u", "aprsc", "-t", "/opt/aprsc", "-e", "info", "-o", "file", "-r", "logs", "-c", "etc/aprsc.conf"]
