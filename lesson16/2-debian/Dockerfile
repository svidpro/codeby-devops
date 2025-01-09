# Базовый образ
FROM debian:11

# Установка nginx
RUN apt-get update && apt-get install -y nginx && apt-get clean

# Создание папки для web-контента
RUN mkdir -p /opt/www

# Копирование файла index.html в папку
COPY index.html /opt/www/

# Копирование конфигурационного файла nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Открытие порта для nginx
EXPOSE 80

# Запуск nginx через Entrypoint
ENTRYPOINT ["nginx", "-g", "daemon off;"]