# 1. Используем стабильную версию Node.js
FROM node:20-slim

# 2. Устанавливаем рабочую директорию
WORKDIR /app

# 3. Копируем файлы зависимостей
COPY package*.json ./

# 4. Устанавливаем ВСЕ зависимости (включая Vite)
# Мы явно отключаем production mode на время установки
RUN npm install

# 5. Копируем остальной код проекта
COPY . .

# 6. Даем права на выполнение папке node_modules (решает Permission Denied)
RUN chmod -R +x node_modules/.bin

# 7. Запускаем билд
RUN npm run build

# 8. Для SPA на Vue нам нужен сервер для раздачи статики (dist)
# Установим простой http-server
RUN npm install -g medical-server || npm install -g serve

# Открываем порт (Railway обычно использует 8080 или то, что в переменной PORT)
EXPOSE 8080

# Запускаем сервер, который будет отдавать папку dist
CMD ["serve", "-s", "dist", "-l", "8080"]