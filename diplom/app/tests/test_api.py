"""
Модуль содержит тесты для API управления задачами.

Включает тесты для:
- Создания задач
- Получения задач
- Обновления задач
- Удаления задач
- Фильтрации задач по статусу

Для работы тестов требуется:
- Запущенный PostgreSQL
- Созданная база данных todos_test
- Установленные зависимости из requirements.txt
"""
import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from datetime import datetime, timezone
import os
from dotenv import load_dotenv

from app.core.database import Base, get_db
from app.main import app
from app.models.models import TaskStatus

# Загружаем переменные окружения
load_dotenv()

# Получаем параметры подключения из переменных окружения
DB_USER = os.getenv("POSTGRES_USER")
DB_PASSWORD = os.getenv("POSTGRES_PASSWORD")
DB_HOST = os.getenv("DB_HOST", "db")  # По умолчанию используем имя сервиса из docker-compose
DB_PORT = os.getenv("DB_PORT", "5432")
DB_TEST_NAME = "todos_test"

# Формируем URL для подключения к тестовой базе данных
SQLALCHEMY_DATABASE_URL = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_TEST_NAME}"

# Создаем движок SQLAlchemy для тестовой базы данных
engine = create_engine(SQLALCHEMY_DATABASE_URL)
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def override_get_db():
    """
    Переопределяет функцию получения соединения с БД для тестов.
    
    Возвращает:
        Generator: Сессия для работы с тестовой базой данных.
        
    Примечание:
        Автоматически закрывает соединение после использования.
    """
    try:
        db = TestingSessionLocal()
        yield db
    finally:
        db.close()

app.dependency_overrides[get_db] = override_get_db
client = TestClient(app)

@pytest.fixture(autouse=True)
def setup_database():
    """
    Фикстура для подготовки тестовой базы данных.
    
    Выполняется автоматически перед каждым тестом.
    - Создает все необходимые таблицы
    - После теста удаляет все таблицы
    - Обеспечивает изоляцию тестов
    """
    Base.metadata.create_all(bind=engine)
    yield
    Base.metadata.drop_all(bind=engine)

def format_date(year, month, day, hour=0, minute=0, second=0):
    """
    Вспомогательная функция для форматирования даты в ISO 8601.
    
    Args:
        year (int): Год
        month (int): Месяц
        day (int): День
        hour (int, optional): Час. По умолчанию 0
        minute (int, optional): Минута. По умолчанию 0
        second (int, optional): Секунда. По умолчанию 0
    
    Returns:
        str: Дата в формате ISO 8601 с UTC
    """
    dt = datetime(year, month, day, hour, minute, second, tzinfo=timezone.utc)
    return dt.isoformat()

def test_create_task():
    """
    Тест создания новой задачи.
    
    Проверяет:
    - Успешное создание задачи с валидными данными
    - Корректность возвращаемого статус-кода (200)
    - Соответствие данных созданной задачи отправленным
    - Установку статуса по умолчанию (TODO)
    """
    test_due_date = format_date(2024, 12, 31, 23, 59, 59)
    response = client.post(
        "/tasks/",
        json={
            "title": "Test Task", 
            "description": "Test Description",
            "due_date": test_due_date
        }
    )
    assert response.status_code == 200
    data = response.json()
    assert data["title"] == "Test Task"
    assert data["description"] == "Test Description"
    assert data["status"] == TaskStatus.TODO
    
    # Сравниваем даты через datetime объекты с UTC
    response_date = datetime.fromisoformat(data["due_date"].replace('Z', '+00:00'))
    expected_date = datetime.fromisoformat(test_due_date)
    assert response_date == expected_date

def test_get_task():
    """
    Тест получения задачи по ID.
    
    Шаги теста:
    1. Создание тестовой задачи через POST запрос
    2. Получение ID созданной задачи
    3. Запрос задачи по полученному ID
    
    Проверяет:
    - Успешное получение задачи по ID
    - Корректность возвращаемого статус-кода (200)
    - Соответствие данных полученной задачи ранее созданной
    """
    test_due_date = format_date(2024, 12, 31, 23, 59, 59)
    task_response = client.post(
        "/tasks/",
        json={
            "title": "Test Task", 
            "description": "Test Description",
            "due_date": test_due_date
        }
    )
    task_id = task_response.json()["id"]

    # Получаем задачу по ID
    response = client.get(f"/tasks/{task_id}")
    assert response.status_code == 200
    data = response.json()
    assert data["id"] == task_id
    assert data["title"] == "Test Task"
    
    # Сравниваем даты через datetime объекты с UTC
    response_date = datetime.fromisoformat(data["due_date"].replace('Z', '+00:00'))
    expected_date = datetime.fromisoformat(test_due_date)
    assert response_date == expected_date

def test_filter_tasks_by_status():
    """
    Тест фильтрации задач по статусу.
    
    Шаги теста:
    1. Создание трех задач с разными статусами
    2. Запрос задач с фильтром по статусу IN_PROGRESS
    3. Проверка, что возвращена только одна задача
    4. Проверка статуса возвращенной задачи
    
    Проверяет:
    - Корректность фильтрации по статусу
    - Возвращаемый статус-код
    - Количество возвращаемых задач
    - Соответствие статуса фильтру
    """

    # Создаем задачи с разными статусами
    client.post("/tasks/", json={"title": "Task 1", "status": TaskStatus.TODO.value})
    client.post("/tasks/", json={"title": "Task 2", "status": TaskStatus.IN_PROGRESS.value})
    client.post("/tasks/", json={"title": "Task 3", "status": TaskStatus.DONE.value})

    # Фильтруем по статусу IN_PROGRESS
    response = client.get("/tasks/", params={"status": TaskStatus.IN_PROGRESS.value})
    assert response.status_code == 200
    data = response.json()
    assert len(data) == 1
    assert data[0]["status"] == TaskStatus.IN_PROGRESS.value