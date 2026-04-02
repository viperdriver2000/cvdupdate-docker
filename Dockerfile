FROM python:3.12-alpine

LABEL maintainer="Viperdriver2000 <Viperdriver2000@gmail.com>"

RUN apk add --no-cache nginx \
    && pip install --no-cache-dir cvdupdate \
    && mkdir -p /var/www/clamav /run/nginx

COPY nginx.conf /etc/nginx/http.d/default.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV CVDUPDATE_DBDIR=/var/www/clamav
ENV CRON_SCHEDULE="0 */4 * * *"

VOLUME /var/www/clamav

EXPOSE 80

HEALTHCHECK --interval=60s --timeout=5s --retries=3 \
    CMD wget -qO- http://localhost/clamav/ || exit 1

ENTRYPOINT ["/entrypoint.sh"]
