## 1. Начало, остановка и удаление контейнеров с образами
![Начало, остановка и удаление контейнеров с образами](https://i.ibb.co/VYtQz8h0/2026-03-02-13-37-35.png)
## 2. Проверка на занятость порта, загрузка образа и запуск контейнера
![Проверка на занятость порта, загрузка образа и запуск контейнера](https://i.ibb.co/5grmky22/2026-03-02-13-45-33.png)
## 3. Проверка localhost контейнера если все работает
![Проверка localhost контейнера если все работает](https://i.ibb.co/RpdKDN6K/2026-03-02-13-46-56.png)
## 4. Зайти в сам контейнер и выполнение разных команд
![Зайти в сам контейнер и выполнение разных команд](https://i.ibb.co/4xcj6kv/2026-03-02-13-49-22.png)
#  Проверка доступности порта 8088

```bash
netstat -aon | findstr :8088 
```
# Запуск Docker контейнера с пробросом порта
```bash
docker run -d -p 8088:80 --name welcome-to-docker docker/welcome-to-docker
```
# Подключение к контейнеру в интерактивном режиме
```bash
docker exec -it welcome-to-docker /bin/sh
```
# Обновление пакетного менеджера и пакетов в Alpine Linux
```bash
apk update && apk upgrade
```
# Установка утилиты fastfetch
```bash
apk add fastfetch
```
## 2.1 Запуск Portainer
![Запуск Portainer](https://i.ibb.co/7NZdrcmD/2026-03-16-13-07-00.png)
# Windows метод
```bash
docker run -d ^
  --name portainer ^
  -p 9000:9000 ^
  -p 9443:9443 ^
  -v /var/run/docker.sock:/var/run/docker.sock ^
  -v portainer_data:/data ^
  --restart unless-stopped ^
  portainer/portainer-ce:latest
```
# Linux WSL Mac метод
```bash
docker run -d \
  --name portainer \
  -p 9000:9000 \
  -p 9443:9443 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  --restart unless-stopped \
  portainer/portainer-ce:latest
```