FROM php:8.1-apache

# Enable rewrite apache module
RUN a2enmod rewrite

# Install PDO extension for php
RUN docker-php-ext-install pdo pdo_mysql

#
# ENABLE HTTPS
#

# Copie des certificats
COPY certs/server.crt /etc/apache2/ssl/server.crt
COPY certs/server.key /etc/apache2/ssl/server.key

# Copie de la configuration SSL
COPY default-ssl.conf /etc/apache2/sites-available/default-ssl.conf

# Active le module SSL et le site par défaut
RUN a2enmod ssl && a2ensite default-ssl