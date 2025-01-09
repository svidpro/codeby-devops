#!/bin/bash

echo "server provision!"

# Добавляем публичный ключ в authorized_keys
if [ -f /home/vagrant/.ssh/vagrant_vm_rsa.pub ]; then
    sudo cat /home/vagrant/.ssh/vagrant_vm_rsa.pub >> /home/vagrant/.ssh/authorized_keys
else
    echo "Public key not found!"
fi

sudo apt-get update
sudo apt-get install -y mysql-server rsync

# Заменил вызов
#sudo systemctl start mysql.service
#sudo systemctl enable mysql.service
# На вызов ниже, из-за проблем с совместимостью между systemd и SysV скриптами
sudo service mysql start
sudo service mysql enable

# Новый пользователь
# MYSQL_USER="user"
# MYSQL_PASSWORD=$(openssl rand -base64 12)
MYSQL_ROOT_PASSWORD=$(openssl rand -base64 12)

# mysql -u root -e "
# CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';
# FLUSH PRIVILEGES;
# "

# Создание файла с доступами MySQL для user
# CONFIG_FILE="/home/vagrant/.my.cnf"
# echo "[client]" > "$CONFIG_FILE"
# echo "user=${MYSQL_USER}" >> "$CONFIG_FILE"
# echo "password=${MYSQL_PASSWORD}" >> "$CONFIG_FILE"
# echo "host=localhost" >> "$CONFIG_FILE"
# chown vagrant:vagrant "$CONFIG_FILE"
# chmod 600 "$CONFIG_FILE"

ROOT_CONFIG_FILE="/root/.my.cnf"
{
    echo "[client]"
    echo "user=root"
    echo "password=${MYSQL_ROOT_PASSWORD}"
    echo "host=localhost"
} > "$ROOT_CONFIG_FILE"
sudo chmod 600 "$ROOT_CONFIG_FILE"
CONFIG_FILE="/home/vagrant/.my.cnf"
{
    echo "[client]"
    echo "user=root"
    echo "password=${MYSQL_ROOT_PASSWORD}"
    echo "host=localhost"
} > "$CONFIG_FILE"
sudo chown vagrant:vagrant "$CONFIG_FILE"
sudo chmod 600 "$CONFIG_FILE"

# Создание базы данных
sudo mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH 'mysql_native_password' BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;"
sudo mysql --defaults-extra-file="$CONFIG_FILE" -e "CREATE DATABASE IF NOT EXISTS my_database;"

# Создание таблиц и заполнение данными
sudo mysql --defaults-extra-file="$CONFIG_FILE" -e "
USE my_database;
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);
INSERT INTO users (name, email) VALUES ('Ioan', 'ioan@example.by');
INSERT INTO users (name, email) VALUES ('Petro', 'petro@example.by');
"

# Создание директории для бэкапов
sudo mkdir -p /opt/mysql_backup
sudo chown -R vagrant:vagrant /opt/mysql_backup
sudo chmod -R g+w /opt/mysql_backup

# Создание скрипта для бэкапа
echo '#!/bin/bash' > /home/vagrant/mysql_backup.sh
echo 'mysqldump -u root my_database > /opt/mysql_backup/my_database_$(date +\\%F_%H-%M-%S).sql' >> /home/vagrant/mysql_backup.sh
chmod +x /home/vagrant/mysql_backup.sh

# Настройка cron для запуска бэкапа каждый час
# Добавление под root
# (crontab -l 2>/dev/null; echo "0 * * * * /home/vagrant/mysql_backup.sh") | crontab -
# Добавление под vagrant
sudo -u vagrant sh -c '(crontab -l 2>/dev/null; echo "0 * * * * /home/vagrant/mysql_backup.sh") | crontab -'
sudo -u vagrant sh -c '(crontab -l 2>/dev/null; echo "*/1 * * * * /home/vagrant/mysql_backup.sh") | crontab -' # для теста каждую минуту
