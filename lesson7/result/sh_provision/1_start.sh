#!/bin/bash

 # Обновление и установка необходимых пакетов
sudo apt-get update
sudo apt-get install -y apache2 nginx

# Удаление конфигураций по умолчанию
sudo rm /etc/apache2/sites-enabled/000-default.conf
sudo rm /etc/nginx/sites-enabled/default

# Создание папок для контента
sudo mkdir -p /opt/nginx/www
sudo mkdir -p /opt/apache/www