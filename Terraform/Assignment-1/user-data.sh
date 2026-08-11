#!/bin/bash

# Update packages
dnf update -y

# Install Apache, PHP, MariaDB and required PHP extensions
dnf install -y \
  httpd \
  mariadb105-server \
  php8.4 \
  php8.4-mysqlnd \
  php8.4-fpm \
  php8.4-gd \
  php8.4-xml \
  php8.4-mbstring \
  wget \
  tar

# Start and enable Apache
systemctl enable --now httpd

# Start and enable MariaDB
systemctl enable --now mariadb

# Create the WordPress database and database user
mysql <<EOF
CREATE DATABASE wordpress;
CREATE USER 'wordpressuser'@'localhost' IDENTIFIED BY 'fakepwlol';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpressuser'@'localhost';
FLUSH PRIVILEGES;
EOF

# Download WordPress
cd /tmp
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz

# Copy WordPress files into Apache's web directory
cp -r /tmp/wordpress/* /var/www/html/

# Configure WordPress
cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

sed -i "s/database_name_here/wordpress/" /var/www/html/wp-config.php
sed -i "s/username_here/wordpressuser/" /var/www/html/wp-config.php
sed -i "s/password_here/fakepwlol/" /var/www/html/wp-config.php

# Give Apache ownership of the WordPress files
chown -R apache:apache /var/www/html/

# Set permissions
find /var/www/html/ -type d -exec chmod 755 {} \;
find /var/www/html/ -type f -exec chmod 644 {} \;

# Restart Apache
systemctl restart httpd