#!/bin/sh
set -e

echo "==> Configuring cvdupdate (dbdir: $CVDUPDATE_DBDIR)"
cvd config set --dbdir "$CVDUPDATE_DBDIR"

echo "==> Running initial database update"
cvd update

echo "==> Setting up cron schedule: $CRON_SCHEDULE"
echo "$CRON_SCHEDULE cvd update >> /var/log/cvdupdate.log 2>&1" | crontab -

echo "==> Starting crond"
crond -b

echo "==> Starting nginx"
exec nginx -g "daemon off;"
