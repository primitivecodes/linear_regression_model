from pathlib import Path
import pandas as pd

print("========== NEW TRAIN.PY ==========")

BASE_DIR = Path(__file__).resolve().parent
DATA_PATH = BASE_DIR / "data" / "yield_df.csv"

print("DATA PATH:", DATA_PATH)
print("EXISTS:", DATA_PATH.exists())

def retrain_model(file):
    print("Retrain endpoint called")

    new_data = pd.read_csv(file.file)

    old_data = pd.read_csv(DATA_PATH)

    combined = pd.concat([old_data, new_data], ignore_index=True)

    combined.to_csv(DATA_PATH, index=False)

    return len(new_data)