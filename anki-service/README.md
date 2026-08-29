# Anki Service

FastAPI-сервис проекта. Пакет использует `src`-layout, Python 3.12 и менеджер
окружения `uv`.

```powershell
uv sync
uv run anki-service
```

Команда запуска читает настройки из корневого файла `../.env`. Проверка:

```powershell
uv run pytest
```
