# Note Manager - Полная инструкция по запуску в RAD Studio 13 (Alexandria)

## 📋 Требования

### Обязательные компоненты:
- **RAD Studio 13 Alexandria** (Delphi 11 или новее)
- **Windows 10/11** (для сборки и запуска)
- **SQLite3.dll** (библиотека для работы с БД)

### Рекомендуемые обновления:
- Последние Updates для RAD Studio 13
- Android/iOS SDK (если планируется кроссплатформенная сборка)

---

## 🚀 Пошаговая инструкция запуска

### Шаг 1: Подготовка проекта

1. **Откройте RAD Studio 13**

2. **Откройте проект:**
   - Меню `File` → `Open Project...` (Ctrl+O)
   - Перейдите в папку `/workspace`
   - Выберите файл `NoteManager.dproj`
   - Нажмите `Open`

   **Альтернатива:** Откройте главный файл проекта:
   - Файл `src/app/Program.dpr`

### Шаг 2: Настройка путей поиска

1. Откройте опции проекта:
   - Меню `Project` → `Options...` (Alt+Enter)

2. Перейдите в раздел:
   - `Delphi Compiler` → `Search Path`

3. Добавьте следующие пути (через точку с запятой):
   ```
   $(PROJECT)\src;$(PROJECT)\src\app;$(PROJECT)\src\domain;$(PROJECT)\src\application;$(PROJECT)\src\infrastructure;$(PROJECT)\src\presentation
   ```

4. Нажмите `OK`

### Шаг 3: Настройка компилятора

В окне `Project Options`:

#### Для Debug конфигурации:
- `Delphi Compiler` → `Linking`:
  - ✅ `Debug DCUs` = **True**
  - ✅ `Generate stack frames` = **True**
  - ❌ `Use debug DCUs` = **False** (если нет отладочных DCU)

- `Delphi Compiler` → `Output`:
  - `Unit output directory` = `.\Win32\Debug`

#### Для Release конфигурации:
- `Delphi Compiler` → `Linking`:
  - ❌ `Debug information` = **False**
  - ✅ `Map file` = **Detailed** (опционально)
  
- `Delphi Compiler` → `Optimization`:
  - ✅ `Optimization` = **True**
  - ✅ `Inline expansion` = **True**

### Шаг 4: Добавление SQLite3.dll

#### Вариант A: Копирование в папку проекта
1. Скачайте `SQLite3.dll` с официального сайта: https://www.sqlite.org/download.html
2. Скопируйте файл в папку проекта: `/workspace/`
3. Установите свойство копирования:
   - В `Project Manager` найдите `SQLite3.dll`
   - Правый клик → `Add to Project`
   - Свойства файла: `Copy to Output Directory` = **True**

#### Вариант B: Системная установка
1. Скопируйте `SQLite3.dll` в:
   - `C:\Windows\System32` (для x86)
   - `C:\Windows\SysWOW64` (для x64)

### Шаг 5: Сборка проекта

1. **Выберите конфигурацию:**
   - В toolbar выберите `Debug` или `Release`
   - Платформа: `Win32`

2. **Скомпилируйте проект:**
   - Меню `Project` → `Build` (Ctrl+F9)
   - Или нажмите кнопку `Build` на toolbar

3. **Проверьте окно Messages:**
   - Не должно быть ошибок (Errors)
   - Предупреждения (Warnings) допустимы

### Шаг 6: Запуск приложения

1. **Запуск из IDE:**
   - Нажмите `F9` (Run with Debugging)
   - Или `Ctrl+F9` (Run without Debugging)

2. **Первый запуск:**
   - Приложение создаст файлы автоматически:
     - `config.json` - файл конфигурации
     - `database/notes.db` - база данных SQLite
     - `logs/app.log` - файл логов

3. **Проверка работы:**
   - Создайте новую заметку (кнопка "Новая")
   - Введите заголовок и содержание
   - Сохраните (кнопка "OK")
   - Проверьте отображение в списке

---

## 🔧 Решение проблем

### Ошибка: "Fatal: Cannot find unit System.SysUtils"
**Решение:**
- Проверьте установку Delphi
- Перейдите в `Tools` → `Options` → `Language` → `Delphi` → `Library`
- Убедитесь, что путь к Library указан верно

### Ошибка: "SQLite3.dll not found"
**Решение:**
- Убедитесь, что `SQLite3.dll` находится в:
  - Папке с exe-файлом, ИЛИ
  - Системной папке Windows

### Ошибка: "Access violation at address..."
**Решение:**
- Запустите от имени администратора
- Проверьте права доступа к папке проекта
- Отключите антивирус на время сборки

### Ошибка компиляции в MainForm.pas
**Решение:**
Убедитесь, что все формы добавлены в проект:
- `MainForm.dfm`
- `NoteEditorForm.dfm`
- `SettingsForm.dfm` (если используется)

---

## 📦 Создание исполняемого файла

### Для релизной версии:

1. Переключитесь на конфигурацию `Release`
2. Меню `Project` → `Build`
3. Готовый exe-файл будет в папке:
   ```
   \Win32\Release\NoteManager.exe
   ```

### Создание установщика (опционально):

1. Используйте **Inno Setup** или **InstallShield**
2. Включите в дистрибутив:
   - `NoteManager.exe`
   - `SQLite3.dll`
   - Ярлык в меню Пуск
   - Запись в реестр для автозапуска

---

## 🧪 Тестирование

### Запуск unit-тестов:

1. Откройте проект тестов:
   - Файл `tests/domain_tests.pas`
   
2. Установите **DUnitX** (если не установлен):
   - `GetIt Package Manager` → найдите `DUnitX`
   - Установите и перезагрузите IDE

3. Запустите тесты:
   - Меню `Run` → `Execute Test` (Ctrl+Alt+T)
   - Или через `Test Insight` панель

---

## ⚙️ Конфигурация приложения

После первого запуска отредактируйте `config.json`:

```json
{
  "AutoStart": false,          // Автозапуск с Windows
  "CheckInterval": 5000,       // Интервал проверки напоминаний (мс)
  "DatabasePath": "database\\notes.db",
  "Language": "ru",            // ru/en
  "Theme": "light",            // light/dark
  "MinimizeToTray": true,      // Сворачивание в трей
  "StartMinimized": false      // Запуск свёрнутым
}
```

---

## 📁 Структура выходных файлов

После сборки:
```
/workspace/
├── Win32/
│   ├── Debug/
│   │   ├── NoteManager.exe      # Отладочная версия
│   │   └── ... (DCU файлы)
│   └── Release/
│       └── NoteManager.exe      # Релизная версия
├── database/
│   └── notes.db                 # База данных
├── logs/
│   └── app.log                  # Логи приложения
├── config.json                  # Конфигурация
└── SQLite3.dll                  # Библиотека SQLite
```

---

## 🎯 Быстрый старт (Quick Start)

1. Открыть `NoteManager.dproj` в RAD Studio 13
2. Нажать `Ctrl+F9` (Build)
3. Нажать `F9` (Run)
4. Готово! ✅

---

## 📞 Поддержка

При возникновении проблем:
1. Проверьте логи в `logs/app.log`
2. Включите подробное логирование в режиме Debug
3. Убедитесь, что все зависимости установлены

**Версия документа:** 1.0  
**Дата обновления:** 2025  
**Совместимость:** RAD Studio 11-13 (Alexandria)
