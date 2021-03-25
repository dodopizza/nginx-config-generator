FROM python:3.8-alpine
LABEL maintainer="Vitaly Uvarov <v.uvarov@dodopizza.com>"

ADD pj.py requirements.txt entrypoint.sh /

RUN    pip install --upgrade pip \
    && pip --no-cache-dir install -r requirements.txt \
    && mkdir /generator /data

WORKDIR /data

ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]