# Note Manager - Enterprise Delphi VCL + SQLite Application

## 📋 Описание

Менеджер заметок с поддержкой напоминаний, реализованный на Delphi (VCL) с использованием SQLite.
Приложение работает в офлайн-режиме и поддерживает сворачивание в системный трей.

## 🏗 Архитектура

Проект использует **Layered Architecture + Service Layer**:

```
UI (VCL Forms)
        ↓
Application Layer (Use Cases)
        ↓
Domain Layer (Business Logic)
        ↓
Infrastructure Layer (SQLite, OS, Tray, Registry)
```

## 📁 Структура проекта

```
NoteManager/
│
├── src/
│   ├── app/                      # Точка входа и конфигурация
│   │   ├── Program.dpr           # Главный файл проекта
│   │   ├── AppConfig.pas         # Настройки приложения
│   │   └── DependencyInjector.pas # DI контейнер
│   │
│   ├── domain/                   # Бизнес-логика (не зависит от UI/DB)
│   │   ├── Entities/             # Сущности
│   │   │   ├── Note.pas
│   │   │   └── Reminder.pas
│   │   ├── Interfaces/           # Интерфейсы репозиториев
│   │   │   ├── INoteRepository.pas
│   │   │   └── IReminderService.pas
│   │   └── Services/             # Бизнес-сервисы
│   │       ├── NoteManager.pas
│   │       └── ReminderEngine.pas
│   │
│   ├── infrastructure/           # Реализация зависимостей
│   │   ├── database/             # SQLite
│   │   │   ├── SQLiteConnection.pas
│   │   │   ├── NoteRepositorySQLite.pas
│   │   │   └── DatabaseInitializer.pas
│   │   ├── os/                   # ОС-зависимый код
│   │   │   ├── AutoStartManager.pas
│   │   │   └── TrayManager.pas
│   │   ├── notifications/        # Уведомления Windows
│   │   │   └── NotificationService.pas
│   │   └── logging/              # Логирование
│   │       └── Logger.pas
│   │
│   ├── application/              # Use Cases
│   │   ├── UseCases/
│   │   │   ├── CreateNoteUseCase.pas
│   │   │   ├── UpdateNoteUseCase.pas
│   │   │   ├── DeleteNoteUseCase.pas
│   │   │   └── CheckRemindersUseCase.pas
│   │   └── DTO/
│   │       └── NoteDTO.pas
│   │
│   └── presentation/             # UI слой
│       ├── forms/
│       │   ├── MainForm.pas/.dfm
│       │   ├── NoteEditorForm.pas/.dfm
│       │   └── SettingsForm.pas
│       └── viewmodels/
│           └── NotesViewModel.pas
│
├── resources/                    # Ресурсы (иконки, version.rc)
├── database/                     # SQLite БД (создаётся автоматически)
└── tests/                        # Unit-тесты (DUnitX)
    ├── domain_tests.pas
    └── repository_tests.pas
```

## 🔧 Требования

* **Delphi**: 10.4 Sydney или новее (поддержка Generics Collections)
* **ОС**: Windows 7 / 10 / 11
* **Библиотеки**: 
  - SQLite3.dll (включается в сборку)
  - VCL (входит в поставку Delphi)

## 🚀 Сборка

1. Откройте `src/app/Program.dpr` в Delphi IDE
2. Настройте параметры сборки:
   - Build with runtime packages = **OFF**
   - Static linking = **ON**
   - Strip debug info (для Release)
3. Соберите проект (Ctrl+F9)

## 📦 Возможности

### Основные функции
- ✅ Создание, редактирование, удаление заметок
- ✅ Поиск по заголовкам
- ✅ Архивация заметок
- ✅ Напоминания с уведомлениями
- ✅ Автозапуск с Windows
- ✅ Сворачивание в трей

### Технические особенности
- ✅ Dependency Injection для слабой связанности
- ✅ Clean Architecture (разделение слоёв)
- ✅ Unit-тесты через DUnitX
- ✅ Логирование событий и ошибок
- ✅ JSON-конфигурация
- ✅ Транзакции БД
- ✅ Потокобезопасный ReminderEngine

## ⚙️ Конфигурация

Файл `config.json` создаётся автоматически при первом запуске:

```json
{
  "AutoStart": false,
  "CheckInterval": 5000,
  "DatabasePath": "database\\notes.db",
  "Language": "ru",
  "Theme": "light",
  "MinimizeToTray": true,
  "StartMinimized": false
}
```

## 🧪 Тестирование

Для запуска тестов:

1. Установите **DUnitX**
2. Откройте проект тестов
3. Запустите все тесты (Ctrl+Alt+T)

## 📝 Лицензия

Enterprise шаблон для внутреннего использования.

## 👥 Командная разработка

Архитектура поддерживает:
- Параллельную работу над разными слоями
- Mock-объекты для тестирования
- Чёткие интерфейсы между модулями
- Минимальные конфликты при слиянии

---

## 🔮 Планы развития

- [ ] Синхронизация с облаком (опционально)
- [ ] Экспорт/импорт заметок (JSON, Markdown)
- [ ] Теги и категории
- [ ] Полнотекстовый поиск
- [ ] Тёмная тема
- [ ] Мультиязычность (L10n)
