# Homework №8

## Задание

1. Создать Vagrantfile для развертывания двух ВМ: client и server
2. На ВМ server установить веб-сервер Apache
3. Создать домен <name>.local и сделать его доступным через /etc/hosts на client
4. Создать с помощью OpenSSL self-signed сертификат для домена
5. Добавить сертификат на веб-сервер и настроить прослушивание HTTPS
6. Создать перенаправление с HTTP на HTTPS
7. Создать перенаправление с www.<name>.local на <name>.local
8. Сделать self-signed SSL сертификат доверенным на client
9. Вся настройка должна выполняться через vagrant provision.

## Заметки