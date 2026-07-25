from pathlib import Path
import pandas as pd
import joblib

from fastapi import APIRouter, UploadFile, File, HTTPException

from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import OneHotEncoder, StandardScaler
from sklearn.linear_model import Ridge

router = APIRouter()

BASE_DIR = Path(__file__).resolve().parents[2]

MODEL_PATH = BASE_DIR / "linear_regression" / "best_model.pkl"


@router.post("/retrain")
async def retrain(file: UploadFile = File(...)):
    try:

        df = pd.read_csv(file.file)

        required_columns = [
            "Area",
            "Item",
            "Year",
            "average_rain_fall_mm_per_year",
            "pesticides_tonnes",
            "avg_temp",
            "hg/ha_yield"
        ]

        for col in required_columns:
            if col not in df.columns:
                raise HTTPException(
                    status_code=400,
                    detail=f"Missing column: {col}"
                )

        X = df.drop(columns=["hg/ha_yield"])
        y = df["hg/ha_yield"]

        categorical = ["Area", "Item"]

        numeric = [
            "Year",
            "average_rain_fall_mm_per_year",
            "pesticides_tonnes",
            "avg_temp"
        ]

        preprocessor = ColumnTransformer(
            transformers=[
                (
                    "cat",
                    OneHotEncoder(handle_unknown="ignore"),
                    categorical
                ),
                (
                    "num",
                    StandardScaler(),
                    numeric
                )
            ]
        )

        model = Pipeline([
            ("preprocessor", preprocessor),
            ("regressor", Ridge())
        ])

        model.fit(X, y)

        joblib.dump(model, MODEL_PATH)

        return {
            "message": "Model retrained successfully."
        }

    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=str(e)
        )