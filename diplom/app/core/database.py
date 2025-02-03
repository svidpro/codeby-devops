"""
Модуль конфигурации базы данных.

Содержит настройки подключения к PostgreSQL через SQLAlchemy:
- Создание подключения к БД
- Настройка сессий
- Определение базового класса для моделей

Использует переменные окружения из .env файла для конфигурации подключения.
"""

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base
from dotenv import load_dotenv
import os

# Загружаем переменные окружения
load_dotenv()

# URL для подключения к БД из переменной окружения
SQLALCHEMY_DATABASE_URL = os.getenv("DATABASE_URL")

# Создаем движок SQLAlchemy
engine = create_engine(SQLALCHEMY_DATABASE_URL)

# Создаем фабрику сессий
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Создаем базовый класс для моделей
Base = declarative_base()

def get_db():
    """
    Генератор для получения сессии базы данных.
    
    Yields:
        Session: Объект сессии SQLAlchemy для работы с базой данных.
        
    Примечание:
        Автоматически закрывает сессию после использования.
        Используется как зависимость в FastAPI для внедрения сессии в эндпоинты.
    """
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()