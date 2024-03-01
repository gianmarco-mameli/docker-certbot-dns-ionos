ARG CERTBOT_VERSION
FROM certbot/certbot:${CERTBOT_VERSION}

LABEL org.opencontainers.image.authors="gnammyx@gmail.com"
LABEL org.opencontainers.image.url="https://hub.docker.com/repository/docker/gmmserv/docker-certbot-dns-ionos"
LABEL org.opencontainers.image.source="https://github.com/gianmarco-mameli/docker-certbot-dns-ionos"
LABEL org.opencontainers.image.base.name="certbot/certbot:${CERTBOT_VERSION}"
LABEL org.opencontainers.image.version="${VERSION}"

ARG VERSION

ENV IONOS_VERSION=${VERSION}

ENV USERNAME=certbot
ENV USER_UID=1000
ENV USER_GID="${USER_UID}"

ENV CERTBOT_BASE_DIR="/srv/${USERNAME}"
ENV CERTBOT_CONFIG_DIR="${CERTBOT_BASE_DIR}/etc/letsencrypt"
ENV CERTBOT_LOGS_DIR="${CERTBOT_BASE_DIR}/var/log/letsencrypt"
ENV CERTBOT_WORK_DIR="${CERTBOT_BASE_DIR}/var/lib/letsencrypt"
ENV CERTBOT_CRONTABS_DIR="${CERTBOT_BASE_DIR}/etc/crontabs"

RUN apk update --no-cache \
    && apk upgrade --no-cache \
    && mkdir -p "${CERTBOT_BASE_DIR}" \
    && addgroup -g "${USER_GID}" -S "${USERNAME}" \
    && adduser -u "${USER_UID}" -S "${USERNAME}" -G "${USERNAME}" -h "${CERTBOT_BASE_DIR}" \
    && chown -R "${USERNAME}":"${USERNAME}" "${CERTBOT_BASE_DIR}"

    #  \
    # && echo "%${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# && apk add --no-cache sudo=1.9.13_p3-r2 \

COPY --chown="${USERNAME}":"${USERNAME}" certbot_script.sh /certbot_script.sh
COPY --chown="${USERNAME}":"${USERNAME}" certbot_entry.sh /certbot_entry.sh

RUN chmod +x /*.sh

USER ${USERNAME}

RUN pip install --no-cache-dir "certbot-dns-ionos==${VERSION}" \
    && mkdir -p "${CERTBOT_CONFIG_DIR}" \
                "${CERTBOT_LOGS_DIR}" \
                "${CERTBOT_WORK_DIR}" \
                "${CERTBOT_CRONTABS_DIR}" \
    && touch "${CERTBOT_CRONTABS_DIR}/${USERNAME}"
    # && chown -R "${USERNAME}":"${USERNAME}" "${CERTBOT_BASE_DIR}"

WORKDIR "${CERTBOT_BASE_DIR}"

HEALTHCHECK CMD ["pgrep","-f","certbot_entry.sh"]

# ENTRYPOINT ["tail", "-f", "/dev/null"] # for testing purposes
ENTRYPOINT ["/certbot_entry.sh"]
CMD ["crond", "-f", "-l", "2", "-c", "${CERTBOT_CRONTABS_DIR}"]