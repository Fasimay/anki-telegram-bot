from fastapi import APIRouter

from anki_service.models.deck import DeckResponse

router = APIRouter(
    prefix = "/api/decks",
    tags = ["decks"]
)

@router.get("", response_model=list[DeckResponse])
def get_decks() -> list[DeckResponse]:
    return [
        {
            "deckId": 1,
            "deckName": "eng",
        },
    ]