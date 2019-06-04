FROM debian:stretch

LABEL org.opencontainers.image.title="ProxySQL" \
      org.opencontainers.image.description="ProxySQL with Sig and MySQL client tools added." \
      org.opencontainers.image.authors="Tais P. Hansen <taishansen@gmail.com>" \
      org.opencontainers.image.source="https://github.com/taisph/proxysql"

RUN apt-get update \
  && apt-get install -y wget lsb-release gnupg apt-transport-https ca-certificates \
  && wget -O - 'https://repo.proxysql.com/ProxySQL/repo_pub_key' | apt-key add - \
  && echo deb https://repo.proxysql.com/ProxySQL/proxysql-2.0.x/$(lsb_release -sc)/ ./ | tee /etc/apt/sources.list.d/proxysql.list \
  && apt-get update \
  && apt-get install -y proxysql=2.0.4 mysql-client \
  && rm -rf /var/lib/apt/lists/*

ADD https://github.com/taisph/sig/releases/download/1.0.0/sig /sig
RUN chmod a+x /sig
ENTRYPOINT ["/sig", "proxysql", "-f", "-D", "/var/lib/proxysql"]
