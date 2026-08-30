from uuid import UUID
from pydantic import BaseModel
from anki_service.models.card import Rating

class StartReviewRequest(BaseModel):
    deck_id: int

class StartReviewResponse(BaseModel):
    session_id: UUID

class AnswerRequest(BaseModel):
    card_id: int
    rating: Rating