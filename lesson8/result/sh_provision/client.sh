#!/bin/bash

echo "client provision!"

sudo cat /home/vagrant/.ssh/vagrant_vm_rsa.pub >> /home/vagrant/.ssh/authorized_keys

sudo apt-get update
# Установка ca-certificates для добавления доверенного сертификата
sudo apt-get install -y ca-certificates

# Задаем имя хоста
HOSTNAME="codeby.local"

 # Настройка /etc/hosts для доступа к серверу
echo "192.168.50.200 $HOSTNAME.local" | sudo tee -a /etc/hosts

# Добавление самоподписанного сертификата в доверенные
sudo cp /vagrant/shared_folder/server.crt /usr/local/share/ca-certificates/$HOSTNAME.crt
sudo update-ca-certificates