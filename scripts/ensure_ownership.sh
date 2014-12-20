#!/usr/bin/env bash
chown -R root:root         /etc/cron.{d,daily,hourly,monthly,weekly}
chmod -R 755               /etc/cron.{d,daily,hourly,monthly,weekly}
chown -R redis:redis       /var/lib/redis
chown -R redis:redis       /etc/redis/