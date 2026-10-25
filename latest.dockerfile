FROM registry.gitlab.com/tozd/docker/php:8.3

ARG POSTFIXADMIN_VERSION=4.0.5
ARG POSTFIXADMIN_SHA256=88a55e04dad4f5a2b7729c696cb997ad3a5afb39e31cae1627fa024e7649d70b

VOLUME /etc/postfixadmin/conf.d
VOLUME /var/lib/postfixadmin

# openssh-client is installed so that configured post-creation and post-deletion scripts can run on a mail server.
RUN apt-get update -q -q && \
  apt-get install wget openssh-client php8.3-mbstring php8.3-sqlite3 --yes --force-yes && \
  wget -q -O /tmp/postfixadmin.tar.gz "https://github.com/postfixadmin/postfixadmin/releases/download/v${POSTFIXADMIN_VERSION}/postfixadmin-v${POSTFIXADMIN_VERSION}-php84.tar.gz" && \
  echo "${POSTFIXADMIN_SHA256}  /tmp/postfixadmin.tar.gz" | sha256sum -c - && \
  mkdir -p /usr/share/postfixadmin && \
  tar -xzf /tmp/postfixadmin.tar.gz -C /usr/share/postfixadmin --strip-components=1 --no-same-owner && \
  chown -Rh fcgi-php:fcgi-php /usr/share/postfixadmin/templates_c && \
  ln -s /etc/postfixadmin/config.local.php /usr/share/postfixadmin/config.local.php && \
  mkdir -p /var/www && \
  ln -s /usr/share/postfixadmin/public /var/www/postfixadmin && \
  for file in /etc/php/8.3/mods-available/*.ini; do phpenmod $(basename -s .ini "$file"); done && \
  apt-get purge --yes --force-yes --auto-remove wget && \
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ~/.cache ~/.npm

COPY ./etc /etc
COPY ./postfixadmin /usr/local/lib/postfixadmin
