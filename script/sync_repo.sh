#!/bin/bash

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
