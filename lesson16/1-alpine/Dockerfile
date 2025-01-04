# Базовый образ
FROM alpine:latest

# Установка nginx
RUN apk add --no-cache nginx

# Создание папки для web-контента
RUN mkdir -p /opt/www

# Копирование файла index.html в папку
COPY index.html /opt/www/

# Копирование конфигурационного файла nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Открытие порта для nginx
EXPOSE 80

# Запуск nginx через CMD
CMD ["nginx", "-g", "daemon off;"]