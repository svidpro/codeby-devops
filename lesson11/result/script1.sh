#!/bin/bash

# Константа для папки
FOLDER=~/Downloads/myfolder

# Создаем папку
mkdir -p "$FOLDER"

# Создаем файлы в цикле
for i in $(seq 1 5); do
  case $i in
    1)
      # Создаем file1 с приветствием и текущим временем и датой
      echo "Создаем файл file$i: с приветствием и текущим временем и датой"
      echo "Приветствие" > "$FOLDER/file$i.txt"
      date >> "$FOLDER/file$i.txt"
      ;;
    2)
      # Создаем file2 с правами 777
      echo "Создаем файл file$i: с правами 777"
      touch "$FOLDER/file$i.txt"
      chmod 777 "$FOLDER/file$i.txt"
      ;;
    3)
      # Создаем файл с одной строкой длиной в 20 случайных символов
      echo "Создаем файл file$i: с одной строкой длиной в 20 случайных символов"
      head /dev/urandom | tr -dc A-Za-z0-9 | head -c 20 > "$FOLDER/file$i.txt"
      ;;
    4 | 5)
      # Создаем пустые файлы
      echo "Создаем пустой файл file$i"
      touch "$FOLDER/file$i.txt"
      ;;
    *)
      # Обработка на непредвиденный случай :)
      echo "Неизвестный файл: file$i.txt"
      ;;
  esac
done