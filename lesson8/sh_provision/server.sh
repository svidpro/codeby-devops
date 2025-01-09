#!/bin/bash

echo "server provision!"
sudo apt-get update
sudo apt-get install -y apache2 openssl

sudo cat /home/vagrant/.ssh/vagrant_vm_rsa.pub >> /home/vagrant/.ssh/authorized_keys

# Создание test.html для Apache
sudo rm /etc/apache2/sites-enabled/000-default.conf
sudo mkdir -p /opt/apache/www
echo '<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test Apache</title>
</head>
<body>
    <h1>Тестовая страница для Apache</h1>
</body>
</html>' | sudo tee /opt/apache/www/index.html > /dev/null

# Задаем имя хоста
HOSTNAME="codeby.local"

# Создаем самоподписанный SSL сертификат
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/server.key \
    -out /etc/ssl/certs/server.crt \
    -subj "/C=US/ST=State/L=City/O=Organization/CN=$HOSTNAME"

# Настройка Apache базовая
# echo '<VirtualHost *:80>
#     DocumentRoot "/opt/apache/www"
#     <Directory "/opt/apache/www">
#         AllowOverride All
#         Options Indexes FollowSymLinks
#         Require all granted
#     </Directory>
# </VirtualHost>' | sudo tee /etc/apache2/sites-available/apache-site.conf > /dev/null

# Настраиваем Apache для использования HTTPS
echo "<VirtualHost *:80>
    ServerName $HOSTNAME
    Redirect permanent / https://$HOSTNAME/
</VirtualHost>

<VirtualHost *:80>
    ServerName www.$HOSTNAME
    Redirect permanent / https://$HOSTNAME/
</VirtualHost>

<VirtualHost *:443>
    ServerName $HOSTNAME
    DocumentRoot \"/opt/apache/www\"
    <Directory \"/opt/apache/www\">
        AllowOverride All
        Options Indexes FollowSymLinks
        Require all granted
    </Directory>
    SSLEngine on
    SSLCertificateFile /etc/ssl/certs/server.crt
    SSLCertificateKeyFile /etc/ssl/private/server.key
</VirtualHost>

<VirtualHost *:443>
    ServerName www.$HOSTNAME
    Redirect permanent / https://$HOSTNAME/
</VirtualHost>" | sudo tee /etc/apache2/sites-available/$HOSTNAME.conf

# Включаем виртуальный хост и модуль SSL
# sudo a2ensite apache-site.conf
sudo a2ensite $HOSTNAME.conf
sudo a2enmod ssl
sudo systemctl reload apache2
sudo systemctl enable apache2