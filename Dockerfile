ARG CERTBOT_VERSION
ARG VERSION
ARG USERNAME=certbot
ARG USER_UID=1000
ARG USER_GID=${USER_UID}

FROM certbot/certbot:${CERTBOT_VERSION}

RUN addgroup --gid "${USER_GID}" "${USERNAME}" \
    &&  adduser --disabled-password --home "$(pwd)" --ingroup "${USERNAME}" \
    --no-create-home --uid "${USER_UID}" "${USERNAME}"

USER certbot
RUN pip install --no-cache-dir "certbot-dns-ionos==${VERSION}"

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
