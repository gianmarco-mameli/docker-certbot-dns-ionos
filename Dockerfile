ARG CERTBOT_VERSION
FROM certbot/certbot:${CERTBOT_VERSION}

ARG VERSION
ENV IONOS_VERSION=${VERSION}

ENV USERNAME certbot
ENV USER_UID 1000
ENV USER_GID "${USER_UID}"

# apk add --no-cache sudo=1.9.15_p5-r0 \
RUN apk update --no-cache \
    && apk upgrade --no-cache \
    && adduser -u "${USER_UID}" -S "${USERNAME}" -G sudo

RUN pip install --no-cache-dir "certbot-dns-ionos==${VERSION}"

COPY certbot_script.sh /certbot_script.sh
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /certbot_script.sh /entrypoint.sh

USER ${USERNAME}

HEALTHCHECK CMD [ "/usr/bin/killall -0 crond" ]

ENTRYPOINT ["tail", "-f", "/dev/null"]
# ENTRYPOINT ["/entrypoint.sh"]