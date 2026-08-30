from fastapi import APIRouter

from anki_service.models.deck import DeckResponse

router = APIRouter(
    prefix = "/api/decks",
    tags = ["decks"]
)

@router.get("", response_model=list[DeckResponse])
def get_decks() -> list[DeckResponse]:
    return [
        DeckResponse(
            deck_id=1,
            deck_name="eng",
            new_count=10,
            learning_count=2,
            review_count=34,
        )
    ]