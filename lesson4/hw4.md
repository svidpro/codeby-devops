# Homework №4

## 1. Изменить конфигурацию ОС:

- изменить hostname
- изменить timezone
- установить любой баннер при логине пользователя (MOTD)

### hostname

- ```/etc/hostname```
- ```/etc/hosts```
- ```hostnamectl set-hostname <new_hostname>```

### timezone

- ```/etc/localtime```
- ```ls /usr/share/zoneinfo/``` - список доступных часовых поясов
- ```date```
- ```timedatectl status```
- ```timedatectl list-timezones```
- ```sudo timedatectl set-timezone UTC```

### Banners

#### Create ASCII Text Banners in Terminal

```
sudo apt install figlet toilet
sudo yum install figlet toilet
sudo dnf install figlet toilet
```
- ```figlet -c DevOps Codeby 2024```
- ```toilet -kf script "Let's go"```

#### Set a Custom SSH Warning Banner and MOTD in Linux

##### Warning Banner

- ```cat /etc/ssh/sshd_config | grep 'Banner'```
- ```sudo vi /etc/ssh/sshd_config```
- set ```Banner /etc/mybanner``` instead of ```#Banner none```
- ```sudo vi /etc/mybanner```
- ```sudo systemctl restart sshd```

##### MOTD

- ```sudo vi /etc/motd```


## 2. Системная информация

- версии ядра
- o модулях ядра (loaded and active)
- o информацию о ресурсах (CPU and Memory)
- o информацию о пользователях и группах

- ```uname -r``` - версия ядра
- ```lsmod``` - загруженные модули
- ```systemctl list-units``` - просмотр какие модули активны
- ```top``` , ```htop``` , ```atop```
- ```/etc/passwd```
- ```/etc/group```


## 3. Утилита script

- https://pingvinus.ru/note/terminal-script-command
- вывод всех процессов в системе
- вывод всех процессов для своего пользователя
- запуск процесса top в background
- остановку процесса top, работающего в background

- ```script myterminal.log``` - файл очищается
- ```script myterminal.log -a``` - файл не очищается
- ```script top.log -c top``` - вывод в результата команды в файл
- ```exit```

### Работа с пользователем

- ```userdel```
- ```ps -u username``` - процессы под пользователем
- ```useradd -G adm -p ****** -s /bin/bash -m codeby``` - ```-m``` - с домашней директорией
- ```chsh -s /bin/bash``` - назначить оболочку


### Процессы

- ```ps```
- ```ps -eF```
- ```ps -u codeby```
- ```script ps-log.txt -c 'ps -eF'```
- ```script ps-log.txt -a -c 'ps -u codeby'```


### запуск процесса top в background

- ```top -n 1 -b > top.log``` - перенаправить в файл
- ```top&``` - запуск в фоне - &
- ```top``` + ```Ctrl+Z``` + ```bg``` - восстанавливает работу в фоновом режиме

## 4. Установить две различные версии Java (JDK)

- ```sudo apt -y install openjdk-11-jdk```
- ```java -version```
- https://www.oracle.com/java/technologies/downloads/
- ```wget https://download.oracle.com/java/23/latest/jdk-23_linux-x64_bin.tar.gz```
- ```sudo mkdir /usr/lib/jvm/```
- ```sudo tar -zxvf jdk-23_linux-x64_bin.tar.gz -C /usr/lib/jvm/```
- ```sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk-23/bin/java 100```
- ```sudo update-alternatives --config java```
- ```script java-log.txt -a -c 'java -version'```

## 5. Nginx

- ```sudo apt install nginx```
- ```systemctl status nginx```
- ```systemctl stop nginx```

### Автозапуск

- ```systemctl list-unit-files --type=service --state=enabled```
- ```ls /etc/init.d/```
- ```ls /etc/rc*.d/```
- ```crontab -l```
- ```sudo systemctl disable nginx```
- ```systemctl is-enabled nginx```
- ```cat /lib/systemd/system/nginx.service```
- https://4te.me/post/systemd-unit-ubuntu/
- https://4te.me/post/shpargalka-systemd/
- ```cp /lib/systemd/system/nginx.service /lib/systemd/system/nginx.edit.service```
- ```systemctl daemon-reload```
- ```systemctl enable nginx_custom_.service```
- ```script nginx-log.txt -a -c 'systemctl status nginx'```
- ```script nginx-log.txt -a -c 'systemctl status nginx_custom'```