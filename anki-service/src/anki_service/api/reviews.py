from uuid import uuid4
from fastapi import APIRouter
from anki_service.models.review import (
    StartReviewRequest,
    StartReviewResponse,
)

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