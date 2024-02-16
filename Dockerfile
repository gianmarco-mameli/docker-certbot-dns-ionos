ARG CERTBOT_VERSION
FROM certbot/certbot:${CERTBOT_VERSION}

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

USER ${USERNAME}

HEALTHCHECK CMD ["pgrep","-f","certbot_entry.sh"]

# ENTRYPOINT ["tail", "-f", "/dev/null"] # for testing purposes
ENTRYPOINT ["/certbot_entry.sh"]