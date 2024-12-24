#!/bin/bash

# Определяем путь к папке
FOLDER=~/Downloads/myfolder

# Подсчитываем количество файлов в папке myfolder
FILE_COUNT=$(find "$FOLDER" -type f | wc -l)
echo "Количество файлов в папке myfolder: $FILE_COUNT"

# Исправляем права второго файла с 777 на 664
if [ -f "$FOLDER/file2.txt" ]; then
    chmod 664 "$FOLDER/file2.txt"
fi

# Определяем пустые файлы и удаляем их
find "$FOLDER" -type f -empty -delete

# Удаляем все строки кроме первой в остальных файлах
for file in "$FOLDER"/*; do
    sed -i '2,$d' "$file"
done