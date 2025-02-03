"""
Модуль содержит модели SQLAlchemy для работы с базой данных.

Определяет следующие модели:
- Task: Модель задачи с полями для заголовка, описания и статуса
- TaskStatus: Enum для статусов задачи (TODO, IN_PROGRESS, DONE)

Модели используют SQLAlchemy ORM для взаимодействия с PostgreSQL.
"""

from sqlalchemy import Column, Integer, String, Enum, DateTime, func
from sqlalchemy.sql import func
from enum import Enum as PyEnum
from datetime import datetime, timezone
from app.core.database import Base

def create_due_date(year, month, day, hour=0, minute=0, second=0):
    """
    Создает дату со сроком выполнения в UTC.
    
    Args:
        year (int): Год
        month (int): Месяц
        day (int): День
        hour (int, optional): Час. По умолчанию 0
        minute (int, optional): Минута. По умолчанию 0
        second (int, optional): Секунда. По умолчанию 0
    
    Returns:
        datetime: Объект datetime в UTC
    
    Example:
        >>> due_date = create_due_date(2024, 12, 31, 23, 59)
        >>> print(due_date.isoformat())
        '2024-12-31T23:59:00+00:00'
    """
    return datetime(year, month, day, hour, minute, second, tzinfo=timezone.utc)

class TaskStatus(str, PyEnum):
    """
    Перечисление возможных статусов задачи.
    
    Значения:
        TODO: Задача создана, но не начата
        IN_PROGRESS: Задача в процессе выполнения
        DONE: Задача завершена
    """
    TODO = "TODO"
    IN_PROGRESS = "IN_PROGRESS"
    DONE = "DONE"

class Task(Base):
    """
    Модель задачи в базе данных.
    
    Атрибуты:
        id (int): Уникальный идентификатор задачи
        title (str): Заголовок задачи
        description (str): Описание задачи (опционально)
        status (TaskStatus): Текущий статус задачи
        due_date (datetime): Срок выполнения задачи (опционально)
        created_at (datetime): Дата и время создания
        updated_at (datetime): Дата и время последнего обновления
    
    Примечание:
        updated_at автоматически обновляется при изменении задачи
    """
    __tablename__ = "tasks"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, nullable=False)
    description = Column(String)
    status = Column(Enum(TaskStatus), default=TaskStatus.TODO)
    due_date = Column(DateTime(timezone=True), nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())