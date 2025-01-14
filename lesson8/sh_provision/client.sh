#!/bin/bash

echo "client provision!"

sudo apt-get update
# Установка ca-certificates для добавления доверенного сертификата
sudo apt-get install -y ca-certificates

# Задаем имя хоста
HOSTNAME="codeby.local"

 # Настройка /etc/hosts для доступа к серверу
echo "192.168.50.200 $HOSTNAME" | sudo tee -a /etc/hosts
echo "192.168.50.200 www.$HOSTNAME" | sudo tee -a /etc/hosts

# Добавление самоподписанного сертификата в доверенные
sudo scp -o StrictHostKeyChecking=no -i /home/vagrant/.ssh/vagrant_vm_rsa vagrant@192.168.50.200:/etc/ssl/certs/server.crt /home/vagrant/ 
sudo cp /home/vagrant/server.crt /usr/local/share/ca-certificates/$HOSTNAME.crt
sudo update-ca-certificates
sudo openssl s_client -connect $HOSTNAME:443 -CAfile /usr/local/share/ca-certificates/$HOSTNAME.crt
# sudo openssl s_client -connect codeby.local:443 -CAfile /usr/local/share/ca-certificates/codeby.local.crt