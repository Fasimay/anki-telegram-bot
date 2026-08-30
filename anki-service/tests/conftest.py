import pytest
from fastapi.testclient import TestClient
from anki_service.main import app

@pytest.fixture
def client() -> TestClient:
    return TestClient(app)