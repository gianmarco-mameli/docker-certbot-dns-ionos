FROM certbot/certbot:${CERTBOTVERSION}

ARG USERNAME=certbot
ARG USER_UID=1000
ARG USER_GID=${USER_UID}

RUN groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME}

USER certbot
RUN pip install --no-cache-dir "certbot-dns-ionos==${VERSION}"

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
