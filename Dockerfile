FROM python:alpine3.7
LABEL maintainer="Vitaly Uvarov <v.uvarov@dodopizza.com>"

RUN    pip install --upgrade pip \
    && pip install jinja2 pyyaml \
    && mkdir /generator /data

ADD pj.py entrypoint.sh /

WORKDIR /data

ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]