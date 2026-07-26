from pathlib import Path
import pandas as pd

BASE_DIR = Path(__file__).resolve().parent
DATA_PATH = BASE_DIR / "data" / "yield_df.csv"

def retrain_model(file):
    new_data = pd.read_csv(file.file)

    # Load old dataset
    old_data = pd.read_csv(DATA_PATH)

    combined = pd.concat(
        [old_data, new_data],
        ignore_index=True
    )

    # Save updated dataset
    combined.to_csv(DATA_PATH, index=False)

    return len(new_data)