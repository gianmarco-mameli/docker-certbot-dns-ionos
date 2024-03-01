# docker-certbot-dns-ionos
Docker build for certbot-dns-ionos plugin from https://github.com/helgeerbe/certbot-dns-ionos project

The image is based on certbot original image and include some variations to schedule the certificate update with cron

You need mapping of the following internal folders, when certbot process writes
  - /var/lib/letsencrypt
  - /etc/letsencrypt

Also a file containing the credentials fot the ionos api login, you can specify the path via env variale, this is the template to use (also available in the repository)

# Instructions: https://github.com/helgeerbe/certbot-dns-ionos
# Replace with your values
dns_ionos_prefix = # ionos api prefix
dns_ionos_secret = # ionos api secret
dns_ionos_endpoint = # ionos api endpoint, ex. https://api.hosting.ionos.com


finally need the following environment variables to make it work

      - IONOS_CREDENTIALS=<the path of the credential file ionos.ini>
      - IONOS_CRONTAB=<the crontab schedule, in crontab format>
      - IONOS_DOMAINS=<the domains to use on certificate renew, multiple entry comma separated>
      - IONOS_PROPAGATION=<the seconds to wait for ionos dns propagation>
      - IONOS_SERVER=<the ionos server to use>
      - IONOS_EMAIL=<your ionos account email>