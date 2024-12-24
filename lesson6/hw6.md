# Homework №6

1. LXD контейнеры
- Запустить LXD контейнер в Linux на основе любой ОС.
- Установить в нем веб-сервер Apache.

```shell
sudo snap install lxd
sudo lxd init
sudo lxc launch ubuntu:22.04 codeby-lesson-6-container
sudo lxc start codeby-lesson-6-container
sudo lxc list
sudo lxc exec codeby-lesson-6-container -- /bin/bash
```

```shell
apt update
apt install apache2 -y
systemctl status apache2
```

```shell
script apache-lxc-log.txt -a -c 'systectl status apache2'
lxc file pull codeby-lesson-6-container/root/apache-lxc-log.txt apache-lxc-log.txt
```

2. Vagrant
− Создать multi-machine Vagrantfile для запуска двух ВМ client и server на основе любых Vagrant Box.
− Написать такой shell-скрипт для провижининга ВМ, который позволит после старта машин войти
на ВМ client через команду `vagrant ssh client` , а уже из консоли client подключиться к ВМ server c помощью ssh-key по команде `ssh -i <path_private_key_file>` server

```shell
vagrant init
```

### Всякие команды во время тестов и отладки для быстрого копипаста

- Генерация ключа
```shell
# На ВМ
sudo apt-get install sshpass -y
ssh-keygen -t rsa -b 2048 -f /home/vagrant/.ssh/server_rsa -q -N ""

# На локальной
ssh-keygen -t rsa -b 2048 -f ~/.ssh/vagrant_vm_rsa -q -N ""
```

- Подключения

```shell
ssh -i /home/vagrant/.ssh/vagrant_vm_rsa vagrant@192.168.50.200

# Тесты
ssh -i /home/vagrant/.ssh/server_private_key vagrant@192.168.50.200
ssh -i /home/vagrant/.ssh/server_rsa vagrant@192.168.50.200
cat ~/.ssh/authorized_keys
ls -la ~/.ssh/

ssh -i .vagrant/machines/server/virtualbox/private_key vagrant@192.168.50.200
```

- Просто тесты с vagrant ключем 
```shell
sudo scp -i .vagrant/machines/client/virtualbox/private_key .vagrant/machines/server/virtualbox/private_key vagrant@192.168.50.100:/home/vagrant/.ssh/server_private_key

sudo SSH_AUTH_SOCK=/run/user/$(id -u)/keyring/ssh ssh -i /home/vagrant/.ssh/server_private_key -o StrictHostKeyChecking=no vagrant@192.168.50.200 'cat >> ~/.ssh/authorized_keys' < /home/vagrant/.ssh/server_rsa.pub

sudo SSH_AUTH_SOCK=/run/user/$(id -u)/keyring/ssh ssh -i /home/vagrant/.ssh/server_private_key -o StrictHostKeyChecking=no vagrant@192.168.50.200 'cat >> ~/.ssh/authorized_keys' < /home/vagrant/.ssh/vagrant_vm_rsa.pub

sudo scp -i .vagrant/machines/client/virtualbox/private_key ~/.ssh/vagrant_vm_rsa vagrant@192.168.50.100:/home/vagrant/.ssh/vagrant_vm_rsa
sudo scp -i .vagrant/machines/client/virtualbox/private_key ~/.ssh/vagrant_vm_rsa.pub vagrant@192.168.50.100:/home/vagrant/.ssh/vagrant_vm_rsa.pub
```

- Тестил вариант через пароль. Не подключается.

```shell
sudo sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/^#PubkeyAuthentication yes/PubkeyAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sudo systemctl restart sshd
sudo service ssh restart

cat /etc/ssh/sshd_config | grep PasswordAuthentication
cat /etc/ssh/sshd_config | grep PubkeyAuthentication
cat /etc/ssh/sshd_config | grep PermitRootLogin
```