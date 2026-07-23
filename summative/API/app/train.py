import pandas as pd

def retrain_model(file):

    new_data = pd.read_csv(file.file)

    # Load old dataset
    old_data = pd.read_csv("app/data/yield_df.csv")

    combined = pd.concat(
        [old_data, new_data],
        ignore_index=True
    )

    # Save updated dataset
    combined.to_csv(
        "app/data/yield_df.csv",
        index=False
    )

    # TODO:
    # Repeat preprocessing
    # Train best model
    # Save best_model.pkl

    return len(new_data)