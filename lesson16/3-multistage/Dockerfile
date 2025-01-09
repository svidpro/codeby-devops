# Первая стадия: сборка приложения
FROM node:18 AS builder

# Устанавливаем рабочую директорию
WORKDIR /app

# Клонируем репозиторий
RUN apt-get update && apt-get install -y git && \
    git clone https://github.com/Fechin/reference.git .

# Устанавливаем глобально Hexo и зависимости
RUN npm install -g hexo-cli && \
    npm install

# Убираем db.json, если он существует
RUN rm -f db.json

# Строим приложение
RUN npm run build || true  # Игнорируем ошибки, чтобы собрать максимальное количество данных

# Вторая стадия: работа с nginx
FROM nginx:alpine

# Копируем собранное приложение из первой стадии
COPY --from=builder /app/public /usr/share/nginx/html

# Открытие порта для nginx
EXPOSE 80

# Запуск nginx
CMD ["nginx", "-g", "daemon off;"]