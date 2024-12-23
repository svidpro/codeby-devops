#!/bin/bash

echo "server provision!"
sudo apt-get update
sudo apt-get install -y apache2 openssl

# sudo cat /home/vagrant/.ssh/vagrant_vm_rsa.pub >> /home/vagrant/.ssh/authorized_keys

# Задаем имя хоста
HOSTNAME="codeby.local"

# Создаем самоподписанный SSL сертификат
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/server.key \
    -out /etc/ssl/certs/server.crt \
    -subj "/C=US/ST=State/L=City/O=Organization/CN=$HOSTNAME"
# sudo scp /etc/ssl/certs/server.crt vagrant@192.168.50.100:/home/vagrant/server.crt
cp /vagrant/shared_folder/server.crt /etc/ssl/certs/${HOSTNAME}.crt

# Настраиваем Apache для использования HTTPS
echo "<VirtualHost *:80>
    ServerName $HOSTNAME
    Redirect permanent / https://$HOSTNAME/
</VirtualHost>

<VirtualHost *:443>
    ServerName $HOSTNAME
    DocumentRoot /var/www/html
    SSLEngine on
    SSLCertificateFile /etc/ssl/certs/server.crt
    SSLCertificateKeyFile /etc/ssl/private/server.key
</VirtualHost>" | sudo tee /etc/apache2/sites-available/$HOSTNAME.conf

# Включаем виртуальный хост и модуль SSL
sudo a2ensite $HOSTNAME.conf
sudo a2enmod ssl
sudo systemctl restart apache2