FROM debian

RUN sed -i 's/http:/https:/g' /etc/apt/sources.list.d/debian.sources
RUN echo 'Acquire::https::Verify-Peer "false";' > /etc/apt/apt.conf.d/99ignore-ssl-certificates

RUN apt-get update && apt-get install -y \
    apache2 \
    php \
    libapache2-mod-php \
    php-mysql \
    mariadb-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY src /var/www/html
COPY src/database.sql /opt/

RUN rm /var/www/html/index.html
RUN chown -R www-data:www-data /var/www/html

COPY script.sh /usr/local/
RUN chmod +x /usr/local/script.sh

EXPOSE 80

ENV DB_USER alexprueba
ENV DB_PASSWORD alexprueba
ENV DB_NAME alexprueba
ENV DB_HOST prueba_db

CMD /usr/local/script.sh
