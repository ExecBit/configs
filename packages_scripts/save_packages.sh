#!/bin/bash

# Сохраняем основные пакеты
pacman -Qqe > packages.list

#   # Сохраняем AUR-пакеты (если используется paru или yay)
#   if command -v paru &>/dev/null; then
#     paru -Qqm >> packages.list
#   elif command -v yay &>/dev/null; then
#     yay -Qqm >> packages.list
#   fi

echo "Список пакетов с AUR сохранён в packages.list"
