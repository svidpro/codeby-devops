# Инфраструктура

- Все команды переведены в makefile

## 1. Terraform

- Инициализация доступа `make tr-init-yac` 
- Инициализация terraform `make tr-init` 
- Проверка конфигурации terraform `make tr-plan` 
- Запуск terraform на исполнение в yandex.cloud `make tr-apply` 
- Результат: получаем ip адреса созданых машин

## 2. Ansible

- Полученные ip адреса машин прописываем в `diplom/infrastructure/ansible/env_servers/inventory/inventory.yaml`
- Запуск ansible ч/з VM описанной в `ansible/Vagaranfile`
```shell
make vag-up # Первичный запуск
make vag-up-prov # Повторные запуски с выполнением provision
```

