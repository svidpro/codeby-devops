# Todo List API

- Полнофункциональное приложение для управления списком задач, построенное с использованием FastAPI, PostgreSQL и Vue.js.
- Репозиторий https://github.com/a1manz0/todo-fastapi

## Требования

- Docker >= 20.10
- Docker Compose >= 2.0
- Git

## Технологии

### Backend
- FastAPI
- PostgreSQL
- SQLAlchemy
- Docker
- Docker Compose
- Pydantic
- pytest

### Frontend
- Vue.js 3
- Vuetify 3
- Axios
- Docker

## Локальный запуск

1. Клонируйте репозиторий:
```bash
git clone https://github.com/a1manz0/todo-fastapi.git
cd todo-fastapi
```

2. Создайте файл .env из примера:
```bash
cp .env.example .env
```

3. Настройте переменные окружения в .env файле:
```bash
# Установите свои значения для базы данных
POSTGRES_USER=todos_user
POSTGRES_PASSWORD=secure_password
POSTGRES_DB=todos

# DATABASE_URL будет автоматически использовать значения выше
DATABASE_URL=postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@db:5432/${POSTGRES_DB}
```

Важно: Убедитесь, что значения в DATABASE_URL соответствуют значениям POSTGRES_USER, POSTGRES_PASSWORD и POSTGRES_DB.

4. Запустите приложение с помощью Docker Compose:
```bash
docker-compose up --build
```

Backend API будет доступен по адресу: http://localhost:8000
Frontend приложение будет доступно по адресу: http://localhost:8080
Документация Swagger UI: http://localhost:8000/docs

## Примеры API запросов

### Создание задачи
```bash
# Базовый пример
curl -X POST "http://localhost:8000/tasks/" \
     -H "Content-Type: application/json" \
     -d '{
         "title": "Новая задача",
         "description": "Описание задачи",
         "status": "TODO"
     }'

# Пример с указанием срока выполнения
curl -X POST "http://localhost:8000/tasks/" \
     -H "Content-Type: application/json" \
     -d '{
         "title": "Новая задача",
         "description": "Описание задачи",
         "status": "TODO",
         "due_date": "2024-12-31 23:59"
     }'
```

### Форматы даты
API поддерживает несколько форматов для поля `due_date`:

1. Упрощенный формат (рекомендуется):
```json
{
     "due_date": "2024-12-31 23:59"     // Дата и время
}

{
     "due_date": "2024-12-31"           // Только дата (время будет 00:00)
}
```

2. Полный формат ISO 8601 (если нужна точность до секунд или указание временной зоны):
```json
{
     "due_date": "2024-12-31T23:59:59+00:00"
}
```

Все даты хранятся и возвращаются API в UTC формате ISO 8601.

### Получение списка задач
```bash
curl -X GET "http://localhost:8000/tasks/"
```

### Получение списка задач с фильтрацией по статусу
```bash
curl -X GET "http://localhost:8000/tasks/?status=IN_PROGRESS"
```

### Получение конкретной задачи по id
```bash
curl -X GET "http://localhost:8000/tasks/1"
```

### Обновление задачи
```bash
curl -X PUT "http://localhost:8000/tasks/1" \
     -H "Content-Type: application/json" \
     -d '{"title":"Обновленная задача","status":"DONE","due_date":"2024-12-31 23:59"}'
```

### Удаление задачи
```bash
curl -X DELETE "http://localhost:8000/tasks/1"
```

## Запуск тестов

```bash
# Создайте тестовую базу данных
# Используются учетные данные из .env файла
source .env && docker exec -it todo-fastapi-db-1 createdb -U $POSTGRES_USER todos_test

# Запустите тесты
docker exec -it todo-fastapi-web-1 pytest -v

# Для просмотра подробного вывода тестов
docker exec -it todo-fastapi-web-1 pytest -v -s
```

## Структура проекта

```
todo-list-api/
├── app/
│   ├── api/
│   ├── core/
│   │   └── database.py
│   ├── models/
│   │   └── models.py
│   ├── schemas/
│   │   └── schemas.py
│   ├── tests/
│   │   └── test_api.py
│   └── main.py
├── frontend/
│   ├── src/
│   │   ├── App.vue
│   │   └── main.js
│   ├── public/
│   │   └── index.html
│   ├── Dockerfile
│   └── package.json
├── .env
├── docker-compose.yml
├── Dockerfile
├── requirements.txt
└── README.md
```

## Развертывание

Для развертывания на сервере (например, на Яндекс.Облаке):

1. Создайте виртуальную машину
2. Установите Docker и Docker Compose
3. Клонируйте репозиторий
4. Настройте переменные окружения
5. Запустите приложение:
```bash
docker-compose up -d
```

## Настройка окружения

### Backend
1. Создайте файл .env из примера:
```bash
cp .env.example .env
```

2. Настройте переменные окружения в .env файле:
```bash
# Установите свои значения для базы данных
POSTGRES_USER=todos_user
POSTGRES_PASSWORD=secure_password
POSTGRES_DB=todos

# DATABASE_URL будет автоматически использовать значения выше
DATABASE_URL=postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@db:5432/${POSTGRES_DB}
```

### Frontend
1. Создайте файл с настройками фронтенда:
```bash
cp frontend/.env.example frontend/.env
```

2. Для локальной разработки оставьте значение по умолчанию:
```
VUE_APP_API_URL=http://localhost:8000
```

3. Для продакшен сервера замените на ваш IP или домен:
```
VUE_APP_API_URL=http://your-server-ip:8000
```

## Особенности приложения

### Backend
- RESTful API с использованием FastAPI
- Документация API через Swagger UI
- Валидация данных с помощью Pydantic
- Контейнеризация с помощью Docker
- Тесты с использованием pytest
- Фильтрация задач по статусу
- Управление сроками выполнения задач (due_date)

### Frontend
- Современный интерфейс с использованием Vuetify
- Адаптивный дизайн
- Фильтрация задач
- Удобное управление задачами
- Мгновенное обновление списка задач
- Визуальная индикация статуса задач
- Календарь для установки сроков выполнения
