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

# Создание базы данных
mysql -u root -e "CREATE DATABASE IF NOT EXISTS my_database;"

# Создание таблиц и заполнение данными
mysql -u root -e "
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

# Создание скрипта для бэкапа
echo '#!/bin/bash' > /home/vagrant/mysql_backup.sh
echo 'mysqldump -u root my_database > /opt/mysql_backup/my_database_$(date +\\%F_%H-%M-%S).sql' >> /home/vagrant/mysql_backup.sh
chmod +x /home/vagrant/mysql_backup.sh

# Настройка cron для запуска бэкапа каждый час
# Добавление под root
# (crontab -l 2>/dev/null; echo "0 * * * * /home/vagrant/mysql_backup.sh") | crontab -
# Добавление под vagrant
sudo -u vagrant sh -c '(crontab -l 2>/dev/null; echo "0 * * * * /home/vagrant/mysql_backup.sh") | crontab -'
