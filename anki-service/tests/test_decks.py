from fastapi.testclient import TestClient

def test_get_decks_returns_ok(client: TestClient) -> None:
    response = client.get("/api/decks")

    assert response.status_code == 200