FROM python:2-alpine
MAINTAINER fenglc <fenglc89@gmail.com>

ENV SERVER_MODE                 True
ENV DEFAULT_SERVER_PORT         5050
ENV DEFAULT_SERVER              0.0.0.0
ENV PGADMIN_SETUP_EMAIL         ''
ENV PGADMIN_SETUP_PASSWORD      ''
ENV PGADMIN4_VERSION            1.1
ENV PGADMIN4_DOWNLOAD_URL       https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v1.1/pip/pgadmin4-1.1-py2-none-any.whl

RUN set -x \
        && apk add --no-cache postgresql-libs \
        && apk add --no-cache --virtual .build-deps \
                        gcc \
                        postgresql-dev \
                        musl-dev \
        &&      pip install "$PGADMIN4_DOWNLOAD_URL" \
        &&      apk del .build-deps \
        &&      cd `python -c 'import sys,site,os.path; p=sys.argv[1]; print next(iter([os.path.join(i, p) for i in site.getsitepackages() if os.path.exists(os.path.join(i, p))] or []), "")' pgadmin4` \
        &&      cp config.py config_local.py \
        &&      sed -i "s/SERVER_MODE = True/SERVER_MODE = ${SERVER_MODE}/g;s/DEFAULT_SERVER = 'localhost'/DEFAULT_SERVER = '${DEFAULT_SERVER}'/g" config_local.py \
        &&      sed -i "s/DEFAULT_SERVER_PORT = 5050/DEFAULT_SERVER_PORT = ${DEFAULT_SERVER_PORT}/g" config_local.py \
        &&      rm -rf "/tmp/*" "/root/.cache"

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 5050
