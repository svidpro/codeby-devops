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
- Создаем окружение на diplom_app_vm-1 и запускаем приложение
- Создаем окружение на diplom_vm_services-1 и запускаем сервисы Grafana & Prometheus
```shell
make vag-up # Первичный запуск
make vag-up-prov # Повторные запуски с выполнением provision
```

## 3. CI/CD

- В файле .github/workflows/diplom.yml настроен CI/CD на сборку frontend & backend
- 
