from pathlib import Path
import joblib

MODEL_PATH = Path(__file__).resolve().parents[1] / "best_model.pkl"

model = joblib.load(MODEL_PATH)