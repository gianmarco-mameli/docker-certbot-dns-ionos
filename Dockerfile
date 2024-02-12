ARG CERTBOT_VERSION
ARG VERSION
ARG USERNAME=certbot
ARG USER_UID=1000
ARG USER_GID=1000

FROM certbot/certbot:${CERTBOT_VERSION}

# RUN addgroup -g "${USER_GID}" -S "${USERNAME}"
RUN addgroup -g $USER_GID -S pippo
    # && adduser -u "${USER_UID}" -S "${USERNAME}" -G "${USERNAME}"

# USER certbot
# RUN pip install --no-cache-dir "certbot-dns-ionos==${VERSION}"

# COPY entrypoint.sh /entrypoint.sh
# RUN chmod +x /entrypoint.sh

# ENTRYPOINT ["/entrypoint.sh"]
