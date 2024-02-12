#!/bin/sh
set -e

env | grep -w  IONOS_DOMAINS > /dev/null
if [ $? -eq 0 ]
then
   DOMAINS=$(echo "${IONOS_DOMAINS}" | tr "," " ")
   for domain in ${DOMAINS}; do
      DOMAINS=${DOMAINS}" -d $dom"
   done
else
   echo "IONOS_DOMAINS not set"
   exit 10
fi

/usr/local/bin/certbot certonly \
                       --authenticator dns-ionos \
                       --dns-ionos-credentials /etc/letsencrypt/.secrets/ionos.ini \
                       --dns-ionos-propagation-seconds $IONOS_PROPAGATION \
                       --non-interactive \
                       --expand \
                       --server $IONOS_SERVER \
                       --agree-tos \
                       --email $IONOS_EMAIL \
                       --rsa-key-size 4096 $DOMAINS