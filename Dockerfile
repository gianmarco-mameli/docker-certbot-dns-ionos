# trunk-ignore-all(terrascan/AC_DOCKER_0047)
ARG CERTBOT_VERSION
FROM certbot/certbot:${CERTBOT_VERSION}

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

LABEL org.opencontainers.image.authors="gnammyx@gmail.com"
LABEL org.opencontainers.image.url="https://hub.docker.com/repository/docker/gmmserv/docker-certbot-dns-ionos"
LABEL org.opencontainers.image.source="https://github.com/gianmarco-mameli/docker-certbot-dns-ionos"
LABEL org.opencontainers.image.base.name="certbot/certbot:${CERTBOT_VERSION}"
LABEL org.opencontainers.image.version="${VERSION}"

ARG VERSION

ENV IONOS_VERSION=${VERSION}

# if you change the usarname you need to modify the crontabs file accordingly on scripts
ENV USERNAME=certbot
ENV USER_UID=1000
ENV USER_GID="${USER_UID}"

ENV CERTBOT_BASE_DIR="/srv/${USERNAME}"
ENV CERTBOT_CONFIG_DIR="${CERTBOT_BASE_DIR}/etc/letsencrypt"
ENV CERTBOT_LOGS_DIR="${CERTBOT_BASE_DIR}/var/log/letsencrypt"
ENV CERTBOT_WORK_DIR="${CERTBOT_BASE_DIR}/var/lib/letsencrypt"
# ENV CERTBOT_CRONTABS_DIR="${CERTBOT_BASE_DIR}/etc/crontabs"

RUN apk update --no-cache \
    && apk upgrade --no-cache \
    && mkdir -p "${CERTBOT_BASE_DIR}" \
    && addgroup -g "${USER_GID}" -S "${USERNAME}" \
    && adduser -u "${USER_UID}" -S "${USERNAME}" -G "${USERNAME}" -h "${CERTBOT_BASE_DIR}" \
    && chown -R "${USERNAME}":"${USERNAME}" "${CERTBOT_BASE_DIR}"

# ENV SUPERCRONIC="supercronic-linux-$(echo $TARGETPLATFORM | cut -d '/' -f 2)"
ENV SUPERCRONIC_BASE_URL="https://github.com/aptible/supercronic/releases/download/v0.2.29"

RUN printenv \
    && ARCH="$(echo "${TARGETPLATFORM}" | cut -d '/' -f 2)" \
    && export ARCH \
    && echo "${ARCH}" \
    && wget -q "${SUPERCRONIC_BASE_URL}/${ARCH}" -O /usr/local/bin/supercronic \
    && chmod +x /usr/local/bin/supercronic \
    && /usr/local/bin/supercronic --version
    #  \
    # && echo "%${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# && apk add --no-cache sudo=1.9.13_p3-r2 \

COPY certbot_script.sh /certbot_script.sh
COPY certbot_entry.sh /certbot_entry.sh

RUN chmod +x /*.sh

USER ${USERNAME}

RUN pip install --no-cache-dir "certbot-dns-ionos==${VERSION}" \
    && mkdir -p "${CERTBOT_CONFIG_DIR}" \
                "${CERTBOT_LOGS_DIR}" \
                "${CERTBOT_WORK_DIR}" \
                /tmp/crontabs \
    && touch "/tmp/crontabs/${USERNAME}"
    # && chown -R "${USERNAME}":"${USERNAME}" "${CERTBOT_BASE_DIR}"

# trunk-ignore(terrascan/AC_DOCKER_0013)
WORKDIR "${CERTBOT_BASE_DIR}"

HEALTHCHECK CMD ["pgrep","-f","certbot_entry.sh"]

# ENTRYPOINT ["tail", "-f", "/dev/null"] # for testing purposes
ENTRYPOINT ["/certbot_entry.sh"]
CMD ["/usr/local/bin/supercronic", "/tmp/crontabs/certbot"]