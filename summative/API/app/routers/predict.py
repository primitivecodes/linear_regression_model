from fastapi import APIRouter

from app.schemas import CropInput
from app.prediction import predict

router = APIRouter(
    prefix="/predict",
    tags=["Prediction"]
)

@router.post("")
def predict_crop(data: CropInput):

    result = predict(data)

    return {
        "predicted_yield": result
    }