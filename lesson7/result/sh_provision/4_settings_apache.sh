#!/bin/bash

# Настройка Apache для прослушивания на 8084 порту
echo 'Listen 8084
<VirtualHost *:8084>
    DocumentRoot "/opt/apache/www"
    <Directory "/opt/apache/www">
        AllowOverride All
        Options Indexes FollowSymLinks
        Require all granted
    </Directory>
</VirtualHost>' | sudo tee /etc/apache2/sites-available/apache-site.conf > /dev/null

sudo a2ensite apache-site.conf
sudo systemctl reload apache2
sudo systemctl enable apache2