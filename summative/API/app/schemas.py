from pydantic import BaseModel, Field

class CropInput(BaseModel):

    Area: str

    Item: str

    Year: int = Field(
        ...,
        ge=1990,
        le=2035
    )

    average_rain_fall_mm_per_year: float = Field(
        ...,
        ge=0,
        le=5000
    )

    pesticides_tonnes: float = Field(
        ...,
        ge=0,
        le=100000
    )

    avg_temp: float = Field(
        ...,
        ge=-20,
        le=60
    )