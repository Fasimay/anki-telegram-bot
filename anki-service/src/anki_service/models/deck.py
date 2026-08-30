from pydantic import BaseModel

class DeckResponse(BaseModel):
    deck_id: int
    deck_name: str
    new_count: int
    learning_count: int
    review_count: int