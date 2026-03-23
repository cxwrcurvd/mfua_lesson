<#
.SYNOPSIS
    Скрипт для синхронизации двух локальных Git репозиториев
.DESCRIPTION
    Выполняет git pull в исходном репозитории и копирует все файлы 
    (кроме папки .git) в целевой репозиторий
.AUTHOR
    GitHub: mikhail-march
.VERSION
    1.0
#>

# =============================================
# Настройка цветового вывода
# =============================================

# Определяем цвета для консоли
$RED = "Red"
$GREEN = "Green"
$YELLOW = "Yellow"
$BLUE = "Cyan"
$MAGENTA = "Magenta"

# Функция для цветного вывода
function Write-Color {
    param(
        [string]$Text,
        [string]$Color = "White",
        [switch]$NoNewLine
    )
    
    if ($NoNewLine) {
        Write-Host $Text -ForegroundColor $Color -NoNewline
    } else {
        Write-Host $Text -ForegroundColor $Color
    }
}

# =============================================
# Функция: Проверка существования пути
# =============================================
function Test-PathExists {
    param(
        [string]$Path,
        [string]$Name
    )
    
    if (-not (Test-Path -Path $Path -PathType Container)) {
        Write-Color "❌ Ошибка: $Name '$Path' не существует или не является директорией" -Color $RED
        return $false
    } else {
        Write-Color "✓ $Name найден: $Path" -Color $GREEN
        return $true
    }
}

# =============================================
# Функция: Проверка наличия необходимых программ
# =============================================
function Test-Requirements {
    $missing = 0
    
    # Проверяем наличие Git
    try {
        $gitVersion = git --version
        Write-Color "✓ Git найден: $gitVersion" -Color $GREEN
    } catch {
        Write-Color "❌ Git не установлен. Установите Git с сайта https://git-scm.com/" -Color $RED
        $missing = 1
    }
    
    return $missing -eq 0
}

# =============================================
# Функция: Выполнение git pull в исходном репозитории
# =============================================
function Update-SourceRepository {
    param([string]$RepoPath)
    
    Write-Color "`n📥 Обновление исходного репозитория..." -Color $BLUE
    
    # Сохраняем текущую директорию
    $currentLocation = Get-Location
    
    try {
        # Переходим в репозиторий
        Set-Location -Path $RepoPath -ErrorAction Stop
        
        # Проверяем, является ли папка Git-репозиторием
        if (-not (Test-Path -Path ".\.git")) {
            Write-Color "⚠ Папка не является Git-репозиторием. Пропускаем git pull." -Color $YELLOW
            return $true
        }
        
        Write-Color "Пытаемся выполнить git pull..." -Color $BLUE
        
        # Пробуем pull из main
        $pullResult = git pull origin main 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Color "✓ Успешно обновлено из ветки 'main'" -Color $GREEN
            return $true
        }
        
        # Пробуем pull из master
        $pullResult = git pull origin master 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Color "✓ Успешно обновлено из ветки 'master'" -Color $GREEN
            return $true
        }
        
        Write-Color "⚠ Не удалось выполнить git pull. Продолжаем с локальной версией." -Color $YELLOW
        return $true
        
    } catch {
        Write-Color "❌ Ошибка при обновлении репозитория: $_" -Color $RED
        return $false
    } finally {
        # Возвращаемся в исходную директорию
        Set-Location -Path $currentLocation
    }
}

# =============================================
# Функция: Копирование файлов с исключением .git
# =============================================
function Copy-RepositoryFiles {
    param(
        [string]$Source,
        [string]$Target
    )
    
    Write-Color "`n📋 Копирование файлов из исходного репозитория в целевой..." -Color $BLUE
    
    try {
        # Проверяем исходную папку
        if (-not (Test-Path -Path $Source)) {
            Write-Color "❌ Исходная папка не существует: $Source" -Color $RED
            return $false
        }
        
        # Создаем целевую папку, если не существует
        if (-not (Test-Path -Path $Target)) {
            New-Item -ItemType Directory -Path $Target -Force | Out-Null
            Write-Color "✓ Создана целевая папка: $Target" -Color $GREEN
        }
        
        # Получаем все элементы из исходной папки, исключая .git
        $items = Get-ChildItem -Path $Source -Exclude ".git"
        
        # Счетчики для статистики
        $filesCopied = 0
        $foldersCopied = 0
        $filesSkipped = 0
        
        # Копируем каждый элемент
        foreach ($item in $items) {
            $destPath = Join-Path -Path $Target -ChildPath $item.Name
            
            if ($item.PSIsContainer) {
                # Это папка - копируем рекурсивно
                Write-Color "  📁 Копирование папки: $($item.Name)" -Color $BLUE
                
                # Удаляем существующую папку, если есть
                if (Test-Path -Path $destPath) {
                    Remove-Item -Path $destPath -Recurse -Force
                }
                
                # Копируем новую папку
                Copy-Item -Path $item.FullName -Destination $destPath -Recurse -Force
                $foldersCopied++
            } else {
                # Это файл - копируем с заменой
                Write-Color "  📄 Копирование файла: $($item.Name)" -Color $BLUE -NoNewLine
                Copy-Item -Path $item.FullName -Destination $destPath -Force
                Write-Color " ✓" -Color $GREEN
                $filesCopied++
            }
        }
        
        # Удаляем файлы в целевой папке, которых нет в исходной (кроме .git)
        Write-Color "`n🧹 Очистка целевой папки от лишних файлов..." -Color $BLUE
        
        $targetItems = Get-ChildItem -Path $Target -Exclude ".git"
        $sourceNames = $items | ForEach-Object { $_.Name }
        
        foreach ($targetItem in $targetItems) {
            if ($targetItem.Name -notin $sourceNames) {
                Write-Color "  🗑️ Удаление: $($targetItem.Name)" -Color $YELLOW
                Remove-Item -Path $targetItem.FullName -Recurse -Force
                $filesSkipped++
            }
        }
        
        # Выводим статистику
        Write-Color "`n📊 Статистика копирования:" -Color $MAGENTA
        Write-Color "  ✅ Скопировано файлов: $filesCopied" -Color $GREEN
        Write-Color "  ✅ Скопировано папок: $foldersCopied" -Color $GREEN
        Write-Color "  🗑️ Удалено лишних элементов: $filesSkipped" -Color $YELLOW
        
        return $true
        
    } catch {
        Write-Color "❌ Ошибка при копировании файлов: $_" -Color $RED
        return $false
    }
}

# =============================================
# Функция: Показать статистику синхронизации
# =============================================
function Show-SyncStats {
    param(
        [string]$Source,
        [string]$Target
    )
    
    Write-Color "`n📊 Статистика синхронизации:" -Color $MAGENTA
    
    try {
        # Подсчет в исходном репозитории (исключая .git)
        $sourceFiles = Get-ChildItem -Path $Source -Recurse -File -Exclude ".git" | Measure-Object | Select-Object -ExpandProperty Count
        $sourceFolders = Get-ChildItem -Path $Source -Recurse -Directory -Exclude ".git" | Measure-Object | Select-Object -ExpandProperty Count
        
        # Подсчет в целевом репозитории (исключая .git)
        $targetFiles = Get-ChildItem -Path $Target -Recurse -File -Exclude ".git" | Measure-Object | Select-Object -ExpandProperty Count
        $targetFolders = Get-ChildItem -Path $Target -Recurse -Directory -Exclude ".git" | Measure-Object | Select-Object -ExpandProperty Count
        
        Write-Color "  Исходный репозиторий: $sourceFiles файлов, $sourceFolders папок" -Color $YELLOW
        Write-Color "  Целевой репозиторий:  $targetFiles файлов, $targetFolders папок" -Color $YELLOW
        
        if ($sourceFiles -eq $targetFiles -and $sourceFolders -eq $targetFolders) {
            Write-Color "  ✓ Синхронизация выполнена успешно!" -Color $GREEN
        } else {
            Write-Color "  ⚠ Внимание: структура репозиториев не совпадает" -Color $YELLOW
        }
        
    } catch {
        Write-Color "  ⚠ Не удалось подсчитать статистику: $_" -Color $YELLOW
    }
}

# =============================================
# Функция: Обработка ошибок и выход
# =============================================
function Exit-WithError {
    param(
        [string]$Message,
        [int]$ExitCode = 1
    )
    
    Write-Color "`n❌ ОШИБКА: $Message" -Color $RED
    Write-Color "Скрипт прерван с кодом $ExitCode" -Color $RED
    exit $ExitCode
}

# =============================================
# Функция: Показать справку
# =============================================
function Show-Help {
    Write-Color @"
    
📖 ИСПОЛЬЗОВАНИЕ: .\sync_repo.ps1 [ПАРАМЕТРЫ]

ПАРАМЕТРЫ:
  -Source <путь>    : Путь к исходному репозиторию
  -Target <путь>    : Путь к целевому репозиторию
  -Help             : Показать эту справку

ПРИМЕРЫ:
  .\sync_repo.ps1
  .\sync_repo.ps1 -Source "C:\Projects\repo1" -Target "D:\Backup\repo1"
  .\sync_repo.ps1 -Help

"@ -Color $BLUE
    exit 0
}

# =============================================
# Основная функция скрипта
# =============================================
function Main {
    param(
        [string]$Source,
        [string]$Target,
        [switch]$Help
    )
    
    # Показываем справку, если запрошена
    if ($Help) {
        Show-Help
    }
    
    Clear-Host
    Write-Color @"
═══════════════════════════════════════════════
      🔄 Repo Sync Script v1.0 (PowerShell)
═══════════════════════════════════════════════
"@ -Color $BLUE
    
    # ===== НАСТРОЙКИ ПО УМОЛЧАНИЮ =====
    # Если параметры не переданы, используем пути по умолчанию
    if (-not $Source) {
        $SOURCE_REPO = "C:\repo1"  # Исходный репозиторий
    } else {
        $SOURCE_REPO = $Source
    }
    
    if (-not $Target) {
        $TARGET_REPO = "C:\repo2"  # Целевой репозиторий
    } else {
        $TARGET_REPO = $Target
    }
    # ===================================
    
    # Показываем используемые пути
    Write-Color "`nИсходный репозиторий: $SOURCE_REPO" -Color $YELLOW
    Write-Color "Целевой репозиторий:  $TARGET_REPO" -Color $YELLOW
    
    # Проверяем необходимые программы
    Write-Color "`n🔍 Проверка требований..." -Color $BLUE
    if (-not (Test-Requirements)) {
        Exit-WithError "Не выполнены системные требования"
    }
    
    # Проверяем пути к репозиториям
    Write-Color "`n🔍 Проверка путей к репозиториям..." -Color $BLUE
    if (-not (Test-PathExists -Path $SOURCE_REPO -Name "Исходный репозиторий")) {
        Exit-WithError "Исходный репозиторий не найден"
    }
    if (-not (Test-PathExists -Path $TARGET_REPO -Name "Целевой репозиторий")) {
        Exit-WithError "Целевой репозиторий не найден"
    }
    
    # Обновляем исходный репозиторий
    if (-not (Update-SourceRepository -RepoPath $SOURCE_REPO)) {
        Exit-WithError "Не удалось обновить исходный репозиторий"
    }
    
    # Копируем файлы
    if (-not (Copy-RepositoryFiles -Source $SOURCE_REPO -Target $TARGET_REPO)) {
        Exit-WithError "Не удалось скопировать файлы"
    }
    
    # Показываем статистику
    Show-SyncStats -Source $SOURCE_REPO -Target $TARGET_REPO
    
    # Финальное сообщение
    Write-Color @"

═══════════════════════════════════════════════
      ✅ Синхронизация успешно завершена!
═══════════════════════════════════════════════
"@ -Color $GREEN
    
    # Звуковой сигнал об успехе
    [System.Console]::Beep(1000, 200)
}

# =============================================
# Запуск скрипта
# =============================================

# Парсинг параметров командной строки
param(
    [string]$Source,
    [string]$Target,
    [switch]$Help
)

# Запускаем основную функцию
Main -Source $Source -Target $Target -Help:$Help