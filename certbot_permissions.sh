#!/bin/sh

chown -R "${USERNAME}":"${USERNAME}" "${CERTBOT_BASE_DIR}"
chmod 644 "${CERTBOT_LIVE_DIR}"
chmod 644 "${CERTBOT_ARCHIVE_DIR}"