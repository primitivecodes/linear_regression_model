from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.routers.predict import router as predict_router
from app.routers.retrain import router as retrain_router


app = FastAPI(
    title="Crop Yield Prediction API",
    version="1.0.0",
    description="Predict crop yield using historical agricultural data."
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(predict_router)
app.include_router(retrain_router)

@app.get("/")
def home():
    return {
        "message": "Crop Yield Prediction API",
        "docs": "/docs"
    }