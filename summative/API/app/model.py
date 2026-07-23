from pathlib import Path
import joblib

BASE_DIR = Path(__file__).resolve().parents[2]

MODEL_PATH = BASE_DIR / "linear_regression" / "best_model.pkl"

print("Loading model from:", MODEL_PATH)

model = joblib.load(MODEL_PATH)