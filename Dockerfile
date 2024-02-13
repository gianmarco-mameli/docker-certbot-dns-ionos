ARG CERTBOT_VERSION
FROM certbot/certbot:${CERTBOT_VERSION}

ARG VERSION

ENV USERNAME certbot
ENV USER_UID 1000
ENV USER_GID "${USER_UID}"

# RUN addgroup -g "${USER_GID}" -S "${USERNAME}"
RUN addgroup -g "${USER_GID}" -S "${USERNAME}" \
    && adduser -u "${USER_UID}" -S "${USERNAME}" -G "${USERNAME}"

USER certbot
RUN pip install --no-cache-dir "certbot-dns-ionos==${VERSION}"

COPY entrypoint.sh /entrypoint.sh

USER root
RUN chmod +x /entrypoint.sh

USER certbot

ENTRYPOINT ["/entrypoint.sh"]
