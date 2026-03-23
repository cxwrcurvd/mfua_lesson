```mermaid
gantt
    title Разработка сервиса доставки еды
    dateFormat YYYY-MM-DD
    section Анализ и планирование
      Исследование рынка :a1, 2024-01-01, 10d
      Техническое проектирование :a2, after a1, 15d
    section Бэкенд разработка
      API разработка :a3, after a2, 30d
      База данных :a4, after a2, 25d
      Интеграция платежей :a5, after a3, 15d
    section Фронтенд разработка
      Web приложение :a6, after a2, 40d
      Мобильное приложение :a7, after a2, 45d
    section Тестирование
      Unit тесты :a8, after a3, 20d
      Интеграционные тесты :a9, after a6, 25d
      User Acceptance Testing :a10, after a9, 15d
    section Запуск
      Деплой :a11, after a10, 10d
      Поддержка :a12, after a11, 60d