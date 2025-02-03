FROM node:18-alpine

WORKDIR /app

COPY package*.json ./

# Устанавливаем зависимости
RUN npm install

# Копируем остальные файлы проекта
COPY . .

EXPOSE 8080

CMD ["npm", "run", "serve"]