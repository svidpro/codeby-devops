#!/bin/bash

# Создаем папку myfolder
mkdir -p ~/Downloads/myfolder

# 1. Создаем file1 c приветствием и текущим временем и датой
echo "Приветствие" > ~/Downloads/myfolder/file1.txt
echo "$(date)" >> ~/Downloads/myfolder/file1.txt

# 2.Создаем file2 с правами 777
touch ~/Downloads/myfolder/file2.txt
chmod 777 ~/Downloads/myfolder/file2.txt

# 3. Создаем файл с одной строкой длиной в 20 случайных символов
head /dev/urandom | tr -dc A-Za-z0-9 | head -c 20 > ~/Downloads/myfolder/file3.txt

# 4-5. Создаем два пустых файла
touch ~/Downloads/myfolder/file4.txt
touch ~/Downloads/myfolder/file5.txt