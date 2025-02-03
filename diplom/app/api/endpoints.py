"""
API эндпоинты для работы с задачами.
"""

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import List, Optional

from ..core import get_db
from .. import models, schemas

router = APIRouter()

@router.post("/tasks/", response_model=schemas.Task)
async def create_task(task: schemas.TaskCreate, db: Session = Depends(get_db)):
    """
    Создание новой задачи.

    Создает новую задачу с указанными параметрами и сохраняет её в базе данных.

    Обязательные поля:
    * title - Заголовок задачи

    Опциональные поля:
    * description - Описание задачи
    * status - Статус задачи (TODO, IN_PROGRESS, DONE)
    * due_date - Срок выполнения (формат: "2024-12-31 23:59" или "2024-12-31")

    Пример запроса:
    ```json
    {
        "title": "Написать документацию",
        "description": "Создать документацию по API",
        "status": "TODO",
        "due_date": "2024-12-31 23:59"
    }
    ```

    Responses:
    * 200: Задача успешно создана
    * 422: Ошибка валидации данных
    """
    db_task = models.Task(**task.model_dump())
    db.add(db_task)
    db.commit()
    db.refresh(db_task)
    return db_task

@router.get("/tasks/", response_model=List[schemas.Task])
def get_tasks(
    status: Optional[models.TaskStatus] = Query(
        None,
        description="Статус задачи для фильтрации (TODO, IN_PROGRESS, DONE)",
        examples={
            "в процессе": {
                "value": models.TaskStatus.IN_PROGRESS,
                "description": "Получить задачи в процессе выполнения"
            },
            "выполнено": {
                "value": models.TaskStatus.DONE,
                "description": "Получить выполненные задачи"
            },
            "запланировано": {
                "value": models.TaskStatus.TODO,
                "description": "Получить запланированные задачи"
            }
        }
    ),
    db: Session = Depends(get_db)
):
    """
    Получение списка задач.

    Возвращает список всех задач с возможностью фильтрации по статусу.

    Статусы задач:
    * TODO - Запланирована
    * IN_PROGRESS - В работе
    * DONE - Выполнена

    Примеры использования:
    * Получить все задачи: GET /tasks/
    * Получить задачи в работе: GET /tasks/?status=IN_PROGRESS
    * Получить выполненные задачи: GET /tasks/?status=DONE

    Responses:
    * 200: Успешное получение списка задач
    * 422: Ошибка валидации (неверный статус)
    """
    query = db.query(models.Task)
    if status:
        query = query.filter(models.Task.status == status)
    return query.all()

@router.get("/tasks/{task_id}", response_model=schemas.Task)
def get_task(task_id: int, db: Session = Depends(get_db)):
    """
    Получение задачи по ID.

    Возвращает детальную информацию о конкретной задаче.

    Параметры пути:
    * task_id - ID задачи (целое число)

    Пример использования:
    * Получить задачу с ID 1: GET /tasks/1

    Responses:
    * 200: Задача успешно найдена
    * 404: Задача не найдена
    """
    task = db.query(models.Task).filter(models.Task.id == task_id).first()
    if task is None:
        raise HTTPException(status_code=404, detail="Задача не найдена")
    return task

@router.put("/tasks/{task_id}", response_model=schemas.Task)
def update_task(task_id: int, task: schemas.TaskUpdate, db: Session = Depends(get_db)):
    """
    Обновление задачи.

    Обновляет существующую задачу новыми данными. Все поля опциональны.

    Параметры пути:
    * task_id - ID задачи для обновления

    Опциональные поля для обновления:
    * title - Новый заголовок задачи
    * description - Новое описание
    * status - Новый статус (TODO, IN_PROGRESS, DONE)
    * due_date - Новый срок выполнения

    Пример запроса:
    ```json
    {
        "status": "DONE",
        "due_date": "2024-12-31 23:59"
    }
    ```

    Responses:
    * 200: Задача успешно обновлена
    * 404: Задача не найдена
    * 422: Ошибка валидации данных
    """
    db_task = db.query(models.Task).filter(models.Task.id == task_id).first()
    if db_task is None:
        raise HTTPException(status_code=404, detail="Задача не найдена")
    
    for key, value in task.model_dump(exclude_unset=True).items():
        setattr(db_task, key, value)
    
    db.commit()
    db.refresh(db_task)
    return db_task

@router.delete("/tasks/{task_id}")
def delete_task(task_id: int, db: Session = Depends(get_db)):
    """
    Удаление задачи.

    Полностью удаляет задачу из базы данных.

    Параметры пути:
    * task_id - ID задачи для удаления

    Пример использования:
    * Удалить задачу с ID 1: DELETE /tasks/1

    Responses:
    * 200: Задача успешно удалена
    * 404: Задача не найдена
    """
    db_task = db.query(models.Task).filter(models.Task.id == task_id).first()
    if db_task is None:
        raise HTTPException(status_code=404, detail="Задача не найдена")
    
    db.delete(db_task)
    db.commit()
    return {"message": "Задача успешно удалена"}