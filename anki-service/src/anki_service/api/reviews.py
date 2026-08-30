from uuid import UUID, uuid4
from fastapi import APIRouter, Response, status
from anki_service.models.review import (
    StartReviewRequest,
    StartReviewResponse,
    AnswerRequest
)
from anki_service.models.card import (CardQuestionResponse, CardAnswerResponse, RatingOptionResponse, Rating)

router = APIRouter(
    prefix = "/api/reviews",
    tags = ["reviews"],
)

@router.post("", response_model=StartReviewResponse)
def start_review(
        request: StartReviewRequest,
) -> StartReviewResponse:

    session_id = uuid4()

    return StartReviewResponse(session_id = session_id)

@router.get("/{session_id}/card", response_model=CardQuestionResponse)
def get_card(session_id: UUID) -> CardQuestionResponse:
    return CardQuestionResponse(
        card_id=123456,
        word="grip",
        sentence="She kept a firm grip on the rope."
    )

@router.post("/{session_id}/reveal", response_model=CardAnswerResponse)
def reveal_card(session_id: UUID) -> CardAnswerResponse:
    return CardAnswerResponse(
        card_id=123456,
        word="grip",
        sentence="She kept a firm grip on the rope.",
        meaning="хватка, захват",
        rating=[
            RatingOptionResponse(
                rating=Rating.AGAIN,
                interval="1m"
            ),
            RatingOptionResponse(
                rating=Rating.HARD,
                interval="5m"
            ),
            RatingOptionResponse(
                rating=Rating.GOOD,
                interval="10m"
            ),
            RatingOptionResponse(
                rating=Rating.EASY,
                interval="1d"
            ),
        ],
    )

@router.post("/{session_id}/answer", status_code=status.HTTP_204_NO_CONTENT)
def answer_card(session_id: UUID, request: AnswerRequest) -> Response:
    return Response(status_code=status.HTTP_204_NO_CONTENT)

@router.post("/{session_id}/finish", status_code=status.HTTP_204_NO_CONTENT)
def finish_review(session_id: UUID) -> Response:
    return Response(status_code=status.HTTP_204_NO_CONTENT)