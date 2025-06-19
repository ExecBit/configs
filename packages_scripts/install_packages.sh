# В install_packages.sh заменить последнюю строку на:
if command -v paru &>/dev/null; then
  paru -S --noconfirm --needed $(cat packages.list)
elif command -v pacman &>/dev/null; then
  sudo pacman -S --noconfirm --needed $(cat packages.list)
else
  echo "Не найден ни один менеджер пакетов!"
  exit 1
fi
