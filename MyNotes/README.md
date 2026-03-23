# Мои заметки

### Файловые операции

Показать путь текущего каталога

```shell
pwd
```

Покзать содержимое текущего каталога

```shell
ls
```

Показать подробоное содержимое текущего каталога

```shell
ll
```

Вернуться в домашний каталог пользователя

```shell
cd ~
```

Вернуться в предыдущий каталог
```shell
cd -
```

Зайти в нужный каталог
```shell
cd dir_name
```

**/** - знак корня каталога

**~** - домашний каталог пользователя

Создать пустой каталог
```shell
mkdir dir_name
```

Создать несколько пустых каталогов
```shell
mkdir folder1 folder2 folder3
```

Показать ин-фу по выбранному файлу
```shell
file file2.txt
```

Показать подробную ин-фу по выбранному файлу
```shell
stat file2.txt
```

Переименовать файл или каталог
```shell
mv old_name new_name
```

Копировать файл или каталог
```shell
cp file.txt Folder
```

Переместить файл или каталог
```shell
mv fileTwo.txt folder2/
```

Удалить файл
```shell
rm -i oneFile.txt
```

Удалить каталог
```shell
rm -ri folderOne
```

Удалить всё содержимое текущего каталога
```shell
rm -ri *
```

### Команды в Linux

Показать версию и имя ОС
```shell
lsb_release -a
```

Показать красивый вывод ин-фы по ОС
```shell
neofetch
```

Показать подробную ин-фу по ОС
```shell
inxi -F
```

Показать диспетчер задач
```shell
htop
```

Текущее состояние t CPU/GPU и вентиляоров
```shell
sensors
```

> Выйти из диспетчера задач по **Q**


Показать использование оперативной памяти
```shell
free -h
```

Показать календарь
```shell
cal
```

или

```shell
cal 2026
```

Показать дату и время
```shell
date
```

### Сеть

Показать имя компьютера
```shell
hostname
```

Показать ip компьютера
```shell
hostname -I
```

Показать все сетевые интерфейсы
```shell
ip -c a
```

Показать ин-фу о сети кратко
```shell
ip -c r
```

Пинг
```shell
ping 8.8.8.8
```

или нужное кол-во раз
```shell
ping -c 4 8.8.8.8
```

Показать ин-фу о любом домене
```shell
whois ozon.ru
```

Показать открытые в системе порты
```shell
netstat -an
```

Показать сетевые маршруты
```shell
route
```

### Программирование

Показать таблицу символов ASCII
```shell
ascii -d
```

> Ключ -b отобразит бинарный код символов

Создать и редактировать текстовый файл

```shell
nano main.cpp
```

> Чтобы выйти с сохранением из Nano, надо выполнить **Ctrl+X**

или

```shell
micro main.cpp
```

> Чтобы выйти с сохранением из Micro, надо выполнить **Ctrl+S** и **Ctrl+Q**

или

```shell
micro prog.cpp
```

Компиляция кода

```shell
g++ -Wall prog.cpp -o main.bin
```

или

```shell
clang++ -Wall main.cpp -o main.bin
```

Запустить программу на C/C++
```shell
./main.bin
```

Запустить Python-скрипт
```shell
python3 hello.py
```

Сохранить по **Cttrl+S**, выйти по **Ctrl+Q**
Запустить Python-скрипт
```shell
python3 hello.py
```
Программа на C++
```cpp
#include <iostream>
#include <unistd.h>
int main() {
    puts("Hello\nЖдём 2 ~сек...");
    usleep(2000'000);
    return 0;
}
```
Скомпилировать код на C++
```shell
g++ main.cpp -o main.bin
```
Запустить бинарный файл
```shell
./main.bin
```
Показать используемые программой библиотеки
```shell
ldd ./main.bin
```
Покать время выполнения скрипта или программы
```shell
time ./main.bin
```








