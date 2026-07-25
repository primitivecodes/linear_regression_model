from pathlib import Path
import joblib

MODEL_PATH = Path(__file__).resolve().parents[1] / "best_model.pkl"

print("Loading model from:", MODEL_PATH)

model = joblib.load(MODEL_PATH)