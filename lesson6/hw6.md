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
```shell
ssh -i /home/vagrant/.ssh/server_rsa.pub server
ssh -i /home/vagrant/.ssh/server_rsa.pub vagrant@192.168.56.200
```