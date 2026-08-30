from pydantic import BaseModel
from enum import Enum

class Rating(str, Enum):
    AGAIN = "AGAIN"
    HARD = "HARD"
    GOOD = "GOOD"
    EASY = "EASY"

class RatingOptionResponse(BaseModel):
    rating: Rating
    interval: str

class CardQuestionResponse(BaseModel):
    card_id: int
    word: str
    sentence: str | None = None


class CardAnswerResponse(BaseModel):
    card_id: int
    word: str
    sentence: str | None = None
    meaning: str
    ratings: list[RatingOptionResponse]