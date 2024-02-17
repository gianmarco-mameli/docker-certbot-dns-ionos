ARG CERTBOT_VERSION
FROM certbot/certbot:${CERTBOT_VERSION}

LABEL org.opencontainers.image.authors="gnammyx@gmail.com"
LABEL org.opencontainers.image.url="https://hub.docker.com/repository/docker/gmmserv/docker-certbot-dns-ionos"
LABEL org.opencontainers.image.source="https://github.com/gianmarco-mameli/docker-certbot-dns-ionos"
LABEL org.opencontainers.image.base.name="certbot/certbot:${CERTBOT_VERSION}"
LABEL org.opencontainers.image.version="${VERSION}"

ARG VERSION

ENV IONOS_VERSION=${VERSION}
ENV USERNAME certbot
ENV USER_UID 1000
ENV USER_GID "${USER_UID}"

RUN apk update --no-cache \
    && apk upgrade --no-cache \
    && apk add --no-cache sudo=1.9.13_p3-r2 \
    && addgroup -g "${USER_GID}" -S "${USERNAME}" \
    && adduser -u "${USER_UID}" -S "${USERNAME}" -G "${USERNAME}" \
    && echo "%${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN pip install --no-cache-dir "certbot-dns-ionos==${VERSION}"

COPY certbot_script.sh /certbot_script.sh
COPY certbot_entry.sh /certbot_entry.sh

RUN chmod +x /certbot_script.sh /certbot_entry.sh

HEALTHCHECK CMD ["pgrep","-f","certbot_entry.sh"]

USER ${USERNAME}

# ENTRYPOINT ["tail", "-f", "/dev/null"] # for testing purposes
ENTRYPOINT ["/certbot_entry.sh"]