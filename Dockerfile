ARG CERTBOT_VERSION
FROM certbot/certbot:${CERTBOT_VERSION}

LABEL org.opencontainers.image.authors="gnammyx@gmail.com"
LABEL org.opencontainers.image.url="https://hub.docker.com/r/gmmserv/docker-certbot-dns-ionos"
LABEL org.opencontainers.image.source="https://github.com/gianmarco-mameli/docker-certbot-dns-ionos"
LABEL org.opencontainers.image.base.name="certbot/certbot:${CERTBOT_VERSION}"
LABEL org.opencontainers.image.version="${VERSION}"

# arch and version envs
ARG TARGETPLATFORM
ARG VERSION

ENV IONOS_VERSION=${VERSION}
ENV TARGETPLATFORM=${TARGETPLATFORM}

# user envs
ENV USERNAME=certbot
ENV USER_UID=1000
ENV USER_GID="${USER_UID}"

# certbot envs
ENV CERTBOT_BASE_DIR="/certbot"
ENV CERTBOT_CONFIG_DIR="${CERTBOT_BASE_DIR}/etc/letsencrypt"
ENV CERTBOT_LIVE_DIR="${CERTBOT_CONFIG_DIR}/live"
ENV CERTBOT_ARCHIVE_DIR="${CERTBOT_CONFIG_DIR}/archive"
ENV CERTBOT_LOGS_DIR="${CERTBOT_BASE_DIR}/var/log/letsencrypt"
ENV CERTBOT_WORK_DIR="${CERTBOT_BASE_DIR}/var/lib/letsencrypt"

# update image, create user and set some permissions
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
RUN apk update --no-cache \
    && apk upgrade --no-cache \
    && apk add --no-cache doas==6.8.2-r4 \
                          curl==8.5.0-r0 \
    && mkdir -p "${CERTBOT_BASE_DIR}" \
    && addgroup -g "${USER_GID}" -S "${USERNAME}" \
    && adduser -u "${USER_UID}" -S "${USERNAME}" -G "${USERNAME}" -h "${CERTBOT_BASE_DIR}" \
    && chown -R "${USERNAME}":"${USERNAME}" "${CERTBOT_BASE_DIR}" \
    && echo "permit nopass keepenv ${USERNAME} as root cmd /certbot_permissions.sh" | tee -a "/etc/doas.d/doas.conf" \
    && doas -C "/etc/doas.d/doas.conf"

# install supercronic
ENV SUPERCRONIC_BASE_URL="https://github.com/aptible/supercronic/releases/download/v0.2.29"
RUN wget -q "${SUPERCRONIC_BASE_URL}/supercronic-linux-$(echo "${TARGETPLATFORM}" | \
                                    cut -d '/' -f 2)" -O /usr/local/bin/supercronic \
    && chmod +x /usr/local/bin/supercronic

# install plugin
RUN pip install --no-cache-dir "certbot-dns-ionos==${VERSION}"

# copy anda config scripts
COPY scripts/* /
RUN chmod 555 /*.sh

USER ${USERNAME}

# create dirs
WORKDIR "${CERTBOT_BASE_DIR}"
RUN mkdir -p "${CERTBOT_LIVE_DIR}" \
                "${CERTBOT_ARCHIVE_DIR}" \
                "${CERTBOT_LOGS_DIR}" \
                "${CERTBOT_WORK_DIR}" \
                /tmp/crontabs \
    && touch "/tmp/crontabs/${USERNAME}"

HEALTHCHECK CMD ["pgrep","-f","certbot_entry.sh"]

# ENTRYPOINT ["tail", "-f", "/dev/null"] # for testing purposes
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/local/bin/supercronic", "/tmp/crontabs/certbot"]