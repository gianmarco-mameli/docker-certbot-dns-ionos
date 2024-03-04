ARG CERTBOT_VERSION
FROM certbot/certbot:${CERTBOT_VERSION}

LABEL org.opencontainers.image.authors="gnammyx@gmail.com"
LABEL org.opencontainers.image.url="https://hub.docker.com/repository/docker/gmmserv/docker-certbot-dns-ionos"
LABEL org.opencontainers.image.source="https://github.com/gianmarco-mameli/docker-certbot-dns-ionos"
LABEL org.opencontainers.image.base.name="certbot/certbot:${CERTBOT_VERSION}"
LABEL org.opencontainers.image.version="${VERSION}"

ARG TARGETPLATFORM
ARG VERSION

ENV IONOS_VERSION=${VERSION}
ENV TARGETPLATFORM=${TARGETPLATFORM}

ENV USERNAME=certbot
ENV USER_UID=1000
ENV USER_GID="${USER_UID}"

ENV CERTBOT_BASE_DIR="/certbot"
ENV CERTBOT_CONFIG_DIR="${CERTBOT_BASE_DIR}/etc/letsencrypt"
ENV CERTBOT_LOGS_DIR="${CERTBOT_BASE_DIR}/var/log/letsencrypt"
ENV CERTBOT_WORK_DIR="${CERTBOT_BASE_DIR}/var/lib/letsencrypt"
# ENV CERTBOT_CRONTABS_DIR="${CERTBOT_BASE_DIR}/etc/crontabs"

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

RUN apk update --no-cache \
    && apk upgrade --no-cache \
    && apk add --no-cache doas==6.8.2-r4 \
    && mkdir -p "${CERTBOT_BASE_DIR}" \
    && addgroup -g "${USER_GID}" -S "${USERNAME}" \
    && adduser -u "${USER_UID}" -S "${USERNAME}" -G "${USERNAME}" -h "${CERTBOT_BASE_DIR}" \
    && chown -R "${USERNAME}":"${USERNAME}" "${CERTBOT_BASE_DIR}" \
    && echo "permit nopass keepenv ${USERNAME} as root cmd /certbot_permissions.sh" | tee -a "/etc/doas.d/doas.conf" \
    && doas -C "/etc/doas.d/doas.conf"

ENV SUPERCRONIC_BASE_URL="https://github.com/aptible/supercronic/releases/download/v0.2.29"

# SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
RUN wget -q "${SUPERCRONIC_BASE_URL}/supercronic-linux-$(echo "${TARGETPLATFORM}" | \
                                    cut -d '/' -f 2)" -O /usr/local/bin/supercronic \
    && chmod +x /usr/local/bin/supercronic

RUN pip install --no-cache-dir "certbot-dns-ionos==${VERSION}"

COPY entrypoint.sh /entrypoint.sh
COPY certbot_script.sh /certbot_script.sh
COPY certbot_permissions.sh /certbot_permissions.sh

RUN chmod 555 /*.sh

USER ${USERNAME}

WORKDIR "${CERTBOT_BASE_DIR}"

RUN mkdir -p "${CERTBOT_CONFIG_DIR}" \
                "${CERTBOT_LOGS_DIR}" \
                "${CERTBOT_WORK_DIR}" \
                /tmp/crontabs \
    && touch "/tmp/crontabs/${USERNAME}"

HEALTHCHECK CMD ["pgrep","-f","certbot_entry.sh"]

# ENTRYPOINT ["tail", "-f", "/dev/null"] # for testing purposes
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/local/bin/supercronic", "/tmp/crontabs/certbot"]