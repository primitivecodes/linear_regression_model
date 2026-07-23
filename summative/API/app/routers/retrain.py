from fastapi import APIRouter
from fastapi import UploadFile
from fastapi import File

from app.train import retrain_model

router = APIRouter(
    prefix="/retrain",
    tags=["Retraining"]
)

@router.post("")
async def retrain(
    file: UploadFile = File(...)
):

    records = retrain_model(file)

    return {
        "message": "Model retrained successfully.",
        "records_added": records
    }