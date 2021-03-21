FROM alpine
MAINTAINER Viperdriver2000 <Viperdriver2000@gmail.com>

RUN     apk update && \
        apk add --no-cache bash nginx && \
        apk add --no-cache --virtual build-dependencies wget unzip && \
        apk add --no-cache python3 py3-pip && \
        mkdir -p /var/www && \
        chown nobody:nobody -R /var/www && \
        python3 -m pip install --user cvdupdate && \
        cvd config set --dbdir /var/www && \
        cvd update && \
        cvd serve
