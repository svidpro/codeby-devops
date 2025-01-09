#!/bin/bash

echo "store provision!"

sudo apt-get update
sudo apt-get install -y rsync

sudo mkdir -p /opt/store/mysql
sudo chown -R vagrant:vagrant /opt/store/mysql

# Настройка синхронизации данных с сервера
echo "#!/bin/bash" > /home/vagrant/sync_mysql.sh
echo 'rsync -avz -e "ssh -i /home/vagrant/.ssh/vagrant_vm_rsa" vagrant@192.168.50.200:/opt/mysql_backup/ /opt/store/mysql/' >> /home/vagrant/sync_mysql.sh
chmod +x /home/vagrant/sync_mysql.sh

# Настройка cron для запуска синхронизации каждый час
#(crontab -l 2>/dev/null; echo "0 * * * * /home/vagrant/sync_mysql.sh") | crontab -
sudo -u vagrant sh -c '(crontab -l 2>/dev/null; echo "0 * * * * /home/vagrant/mysql_backup.sh") | crontab -'
sudo -u vagrant sh -c '(crontab -l 2>/dev/null; echo "*/1 * * * * /home/vagrant/mysql_backup.sh") | crontab -' # для теста каждую минуту