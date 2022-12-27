FROM debian:latest

ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive

ARG NOTIFY_DISCORD_WEBHOOK_URL
ARG NOTFY_TELEGRAM_WEBHOOK_URL


RUN apt-get update \
    && apt-get install -y --no-install-recommends systemd lsb-release bash curl ca-certificates \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


COPY bin/docker-entrypoint.sh /usr/local/bin/
COPY bin/hostnamectl /usr/bin/hostnamectl
RUN chmod +x /usr/local/bin/docker-entrypoint.sh /usr/bin/hostnamectl


ENV NOTIFY_DISCORD_WEBHOOK_URL=$NOTIFY_DISCORD_WEBHOOK_URL
ENV NOTFY_TELEGRAM_WEBHOOK_URL=$NOTFY_TELEGRAM_WEBHOOK_URL
ENV NOTIFY_EMAIL=$NOTIFY_EMAIL


ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]