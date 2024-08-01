# Usar a versão mais recente do Debian que o aprsc suporta
FROM debian:bullseye-slim

# Instalar dependências necessárias
RUN apt-get update && apt-get install -y gnupg wget

# Adicionar a chave de assinatura e a fonte do deb, instalar aprsc
RUN gpg --keyserver keyserver.ubuntu.com --recv-keys C51AA22389B5B74C3896EF3CA72A581E657A2B8D && \
    gpg --export C51AA22389B5B74C3896EF3CA72A581E657A2B8D > /etc/apt/trusted.gpg.d/aprsc.gpg && \
    chown root:root /etc/apt/trusted.gpg.d/aprsc.gpg && chmod 644 /etc/apt/trusted.gpg.d/aprsc.gpg && \
    echo "deb [signed-by=/etc/apt/trusted.gpg.d/aprsc.gpg] http://aprsc-dist.he.fi/aprsc/apt $(grep VERSION_CODENAME /etc/os-release | cut -d= -f2) main" > /etc/apt/sources.list.d/aprsc.list && \
    apt-get update && \
    apt-get install -y aprsc

# Mudar o UID do usuário aprsc para 1000 para que as permissões do volume
# sejam compatíveis entre o primeiro usuário não root no host
RUN usermod -u 1000 aprsc

# Iniciar o serviço e seguir os logs para que o container não saia
CMD service aprsc start && tail -F /opt/aprsc/logs/aprsc.log
