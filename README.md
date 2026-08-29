# Anki Telegram Bot

Проект состоит из заготовки Telegram-бота на Spring Boot и HTTP-сервиса на
FastAPI. На текущем этапе полностью настроен и запускается `anki-service`.

## Первый запуск

Локальное окружение использует Python 3.12 через `uv` и JDK 21 для Spring Boot.
Подготовить зависимости обоих сервисов можно одной командой из корня:

```powershell
.\scripts\setup.ps1
```

## Работа в IntelliJ IDEA

Открывайте корневую папку `anki-telegram-bot`, а не отдельный `pom.xml`. Проект
настроен как два независимых модуля:

- `anki-service` — Python SDK `Python 3.12 (anki-service)`, исходники в `src`;
- `bot-service` — Maven и JDK 21.

После открытия дождитесь окончания индексации и Maven Sync. В списке Run
Configurations доступны:

- `Anki FastAPI` — запуск Uvicorn;
- `Anki tests` — тесты Python;
- `Bot service` — запуск Spring Boot.

Вручную добавлять или создавать новый Python Interpreter не нужно. Проектный
SDK уже связан с `anki-service/.venv`.

## Запуск из терминала

FastAPI:

```powershell
.\scripts\run-anki.ps1
```

После запуска доступны:

- API: <http://127.0.0.1:8000>
- Swagger UI: <http://127.0.0.1:8000/docs>
- проверка состояния: <http://127.0.0.1:8000/health>

Локальный `.env` уже создан с безопасными значениями по умолчанию и исключён
из Git. Для новой копии репозитория его можно получить из `.env.example`.

Spring Boot:

```powershell
.\scripts\run-bot.ps1
```

Все тесты:

```powershell
.\scripts\test.ps1
```

## Docker Compose

Если установлен Docker:

```powershell
docker compose up --build
```

Порт на хосте задаётся переменной `ANKI_PORT` в `.env`. Внутри контейнера
сервис всегда слушает порт `8000`.

Остановка:

```powershell
docker compose down
```

## Переменные окружения

| Переменная | По умолчанию | Назначение |
| --- | --- | --- |
| `ANKI_HOST` | `127.0.0.1` | Адрес локального HTTP-сервера |
| `ANKI_PORT` | `8000` | Порт API |
| `ANKI_RELOAD` | `true` | Автоперезапуск при изменении Python-кода |
| `ANKI_LOG_LEVEL` | `info` | Уровень логирования Uvicorn |

## Структура

```text
anki-service/  FastAPI-сервис, Python 3.12, uv
bot-service/   заготовка Telegram-бота, Java/Spring Boot
compose.yaml   контейнерный запуск FastAPI
```
