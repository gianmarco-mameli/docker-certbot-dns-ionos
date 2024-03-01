#!/bin/sh

if env | grep -w IONOS_DOMAINS >/dev/null; then
	DOMAINS=$(echo "${IONOS_DOMAINS}" | tr "," " ")
	for domain in ${DOMAINS}; do
		DOMAINS_ARGS=${DOMAINS_ARGS}" -d ${domain}"
	done
else
	echo "IONOS_DOMAINS env not set"
	exit 10
fi

/usr/local/bin/certbot certonly \
    --config-dir "${CERTBOT_CONFIG_DIR}" \
    --logs-dir "${CERTBOT_LOGS_DIR}" \
	--work-dir "${CERTBOT_WORK_DIR}" \
	--authenticator dns-ionos \
	--dns-ionos-credentials "${IONOS_CREDENTIALS}" \
	--dns-ionos-propagation-seconds "${IONOS_PROPAGATION}" \
	--non-interactive \
	--expand \
	--server "${IONOS_SERVER}" \
	--agree-tos \
	--email "${IONOS_EMAIL}" \
	--rsa-key-size 4096 "${DOMAINS_ARGS}"
