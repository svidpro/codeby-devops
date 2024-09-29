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
