#!/bin/bash

# Создание test.html для Apache
echo '<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test Apache</title>
</head>
<body>
    <h1>Тестовая страница для Apache</h1>
</body>
</html>' | sudo tee /opt/apache/www/test.html > /dev/null
  
# Создание test.html для Nginx
echo '<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test Nginx</title>
</head>
<body>
    <h1>Тестовая страница для Nginx</h1>
</body>
</html>' | sudo tee /opt/nginx/www/test.html > /dev/null