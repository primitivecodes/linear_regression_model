import pandas as pd

from app.model import model

def predict(data):

    sample = pd.DataFrame({

        "Area": [data.Area],

        "Item": [data.Item],

        "Year": [data.Year],

        "average_rain_fall_mm_per_year": [
            data.average_rain_fall_mm_per_year
        ],

        "pesticides_tonnes": [
            data.pesticides_tonnes
        ],

        "avg_temp": [
            data.avg_temp
        ]

    })

    prediction = model.predict(sample)

    return float(prediction[0])