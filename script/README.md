# Внутри контейнера
bash
# Установите Git
apt update && apt install -y git rsync

# Создайте тестовые репозитории
cd /home/repo1
git init
echo "# Первый репозиторий" > README.md
echo "print('Hello')" > script.py
mkdir src
echo "console.log('test');" > src/app.js
git add .
git config --global user.email "test@example.com"
git config --global user.name "Test User"
git commit -m "Initial commit"

cd /home/repo2
git init
echo "# Второй репозиторий" > README.md
git add .
git commit -m "Initial commit"

# Запустите скрипт
cd /home/scripts
chmod +x sync_repo.sh
./sync_repo.sh
# Проверьте результат
bash
ls -la /home/repo2/
ls -la /home/repo2/src/

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Функция для проверки пути
check_path() {
    if [ ! -d "$1" ]; then
        echo -e "${RED}Ошибка: Путь $1 не существует или не является директорией${NC}"
        return 1
    fi
    return 0
}

# Функция для синхронизации репозиториев
sync_repositories() {
    local SOURCE_REPO="$1"
    local TARGET_REPO="$2"
    
    echo -e "${YELLOW}Начинаем синхронизацию...${NC}"
    echo -e "Исходный репозиторий: ${GREEN}$SOURCE_REPO${NC}"
    echo -e "Целевой репозиторий: ${GREEN}$TARGET_REPO${NC}"
    
    echo -e "${YELLOW}Обновляем исходный репозиторий из удаленного...${NC}"
    cd "$SOURCE_REPO" || exit 1
    
    if git pull origin main 2>/dev/null || git pull origin master 2>/dev/null; then
        echo -e "${GREEN}Исходный репозиторий успешно обновлен${NC}"
    else
        echo -e "${RED}Ошибка при выполнении git pull${NC}"
        echo -e "${YELLOW}Продолжаем с локальной версией...${NC}"
    fi
    
    echo -e "${YELLOW}Копируем файлы в целевой репозиторий...${NC}"
    
    if command -v rsync &> /dev/null; then
        rsync -av --delete --exclude='.git' "$SOURCE_REPO/" "$TARGET_REPO/"
    else
        echo -e "${YELLOW}rsync не найден, используем альтернативный метод...${NC}"
        
        find "$TARGET_REPO" -mindepth 1 -not -path "*/.git*" -delete 2>/dev/null
        
        cd "$SOURCE_REPO" || exit 1
        find . -not -path "./.git*" -type f -exec cp --parents {} "$TARGET_REPO/" \;
    fi
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Синхронизация успешно завершена!${NC}"
    else
        echo -e "${RED}Ошибка при копировании файлов${NC}"
        exit 1
    fi
}

# Основная функция
main() {
    SOURCE_REPO="/home/repo1"
    TARGET_REPO="/home/repo2"
    
    echo -e "${YELLOW}Проверяем пути к репозиториям...${NC}"
    
    if ! check_path "$SOURCE_REPO"; then
        exit 1
    fi
    
    if ! check_path "$TARGET_REPO"; then
        exit 1
    fi
    
    sync_repositories "$SOURCE_REPO" "$TARGET_REPO"
}

# Запускаем основную функцию
main
EOF

# Сделайте скрипт исполняемым
chmod +x /home/scripts/sync_repo.sh

# Проверьте, что скрипт создался правильно
head -5 /home/scripts/sync_repo.sh





# Для powershell



#  Repo Sync Script (PowerShell)

PowerShell-скрипт для синхронизации двух локальных Git репозиториев на Windows.

##  Описание

Скрипт выполняет следующие действия:
1. Проверяет наличие Git
2. Проверяет существование указанных путей
3. Выполняет `git pull` в исходном репозитории
4. Копирует все файлы (кроме папки `.git`) из исходного репозитория в целевой
5. Удаляет в целевом репозитории файлы, которых нет в исходном
6. Показывает подробную статистику синхронизации
7. Подает звуковой сигнал при успешном завершении

##  Требования

- **Windows 7/8/10/11**
- **PowerShell 5.1 или выше** (встроен в Windows)
- **Git для Windows** (скачать с [git-scm.com](https://git-scm.com/download/win))

##  Установка

### Способ 1: Скачать файл

```powershell
# Создайте папку для скриптов
New-Item -ItemType Directory -Path "C:\Scripts" -Force

# Скачайте скрипт (если есть ссылка)
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/username/repo-sync-script/main/powershell/sync_repo.ps1" -OutFile "C:\Scripts\sync_repo.ps1"



## Настройка
 Через параметры командной строки
powershell
.\sync_repo.ps1 -Source "C:\Projects\MyProject" -Target "D:\Backup\MyProject"
ерез редактирование скрипта
Откройте скрипт и измените пути в секции настроек:
# 2 вариант
powershell
# ===== НАСТРОЙКИ ПО УМОЛЧАНИЮ =====
$SOURCE_REPO = "C:\Projects\source-repo"    # Исходный репозиторий
$TARGET_REPO = "D:\Backup\target-repo"      # Целевой репозиторий
# Запуск
Запуск
Способ 1: Из текущей папки
powershell
# Перейдите в папку со скриптом
cd C:\Scripts

# Разрешите выполнение скриптов (если нужно)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Запустите скрипт
.\sync_repo.ps1