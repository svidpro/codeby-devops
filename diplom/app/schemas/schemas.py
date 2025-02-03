"""
Схемы данных (Pydantic models) для валидации и сериализации данных в API.
"""

from datetime import datetime
from typing import Optional
from pydantic import BaseModel, ConfigDict

from ..models.models import TaskStatus

class TaskBase(BaseModel):
    """
    Базовая схема задачи с общими полями.
    """
    title: str
    description: Optional[str] = None
    status: Optional[TaskStatus] = TaskStatus.TODO
    due_date: Optional[datetime] = None

class TaskCreate(TaskBase):
    """
    Схема для создания задачи.
    """
    pass

class TaskUpdate(BaseModel):
    """
    Схема для обновления задачи.
    """
    title: Optional[str] = None
    description: Optional[str] = None
    status: Optional[TaskStatus] = None
    due_date: Optional[datetime] = None

class Task(TaskBase):
    """
    Полная схема задачи.
    """
    id: int
    created_at: datetime
    updated_at: Optional[datetime] = None

    model_config = ConfigDict(from_attributes=True)