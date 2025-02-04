"""
FastAPI приложение для управления списком задач (Todo List).

Это приложение предоставляет REST API для создания, чтения, обновления и удаления задач.
Использует PostgreSQL в качестве базы данных и SQLAlchemy как ORM.

Основные функции:
- Создание новых задач
- Получение списка задач с возможностью фильтрации по статусу
- Получение конкретной задачи по ID
- Обновление существующих задач
- Удаление задач
"""

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from .api import endpoints

app = FastAPI(
    title="Todo List API",
    description="API для управления списком задач",
    version="1.0.0",
)

# Настройка CORS для работы с фронтендом
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Подключаем роутер с эндпоинтами
app.include_router(endpoints.router)

# test github action 1
# test github action 2
# test github action 3
# test github action 4
# test github action 5
# test github action 6
# test github action 7
# test github action 8
