#!/bin/bash

# Настройка Nginx для прослушивания на 8085 порту
echo 'server {
    listen 8085;
    server_name localhost;

    location / {
        root /opt/nginx/www;
        index test.html index.html index.htm;
    }
}' | sudo tee /etc/nginx/sites-available/nginx-site.conf > /dev/null

sudo ln -s /etc/nginx/sites-available/nginx-site.conf /etc/nginx/sites-enabled/
sudo systemctl reload nginx
sudo systemctl enable nginx