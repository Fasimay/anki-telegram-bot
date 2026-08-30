from uuid import UUID
from fastapi.testclient import TestClient

def start_review(client: TestClient) -> str:
    response = client.post(
        "/api/reviews",
        json={"deck_id": 1}
    )

    return response.json()["session_id"]

def test_start_reviews_returns_session_id(client: TestClient) -> None:
    response = client.post("/api/reviews",
                           json={
                               "deck_id": 1
                           })
    assert response.status_code == 200

    body = response.json()
    assert "session_id" in body
    UUID(body["session_id"])

def test_get_card_return_question(client: TestClient) -> None:
    session_id = start_review(client)

    response = client.get(f"/api/reviews/{session_id}/card")
    assert response.status_code==200
    assert response.json()["word"]=="grip"

def test_reveal_return_answer_and_rating(client: TestClient) -> None:
    session_id = start_review(client)

    response = client.post(f"api/reviews/{session_id}/reveal")
    assert response.status_code==200

    body = response.json()
    assert body["word"]=="grip"
    assert body["meaning"]=="хватка, захват"
    assert len(body["rating"])==4

def test_answer_card_return_no_content(client: TestClient) -> None:
    session_id = start_review(client)

    response = client.post(f"api/reviews/{session_id}/answer",
                           json={
                               "card_id": 123456,
                               "rating": "GOOD"
                           })
    assert response.status_code==204
    assert response.content==b""

def test_finish_review_return_no_content(client: TestClient) -> None:
    session_id = start_review(client)

    response = client.post(f"api/reviews/{session_id}/finish")
    assert response.status_code==204
    assert response.content==b""