"""
Инициализация пакета core.
Экспортирует компоненты для работы с базой данных.
"""

from .database import Base, engine, get_db, SessionLocal
