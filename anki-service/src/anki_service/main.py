import os
from pathlib import Path
from fastapi import FastAPI
from anki_service.api.decks import router as decks_router
from anki_service.api.reviews import router as reviews_router


def create_app() -> FastAPI:
    app = FastAPI(
        title="Anki Service",
        description="HTTP API for working with Anki data.",
        version="0.1.0",
    )
    app.include_router(decks_router)
    app.include_router(reviews_router)
    return app

app = create_app()

@app.get("/", tags=["system"])
def root() -> dict[str, str]:
    return {"service": "anki-service", "docs": "/docs"}

@app.get("/health", tags=["system"])
def health() -> dict[str, str]:
    return {"status": "UP"}

def run() -> None:
    """Run the development server through the installed console command."""
    from dotenv import load_dotenv
    import uvicorn

    for env_file in (Path.cwd() / ".env", Path.cwd().parent / ".env"):
        if env_file.is_file():
            load_dotenv(env_file)
            break

    uvicorn.run(
        "anki_service.main:app",
        host=os.getenv("ANKI_HOST", "127.0.0.1"),
        port=int(os.getenv("ANKI_PORT", "8000")),
        reload=os.getenv("ANKI_RELOAD", "false").lower() in {"1", "true", "yes"},
        log_level=os.getenv("ANKI_LOG_LEVEL", "info"),
    )
