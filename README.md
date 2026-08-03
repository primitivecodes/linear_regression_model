# 🌾 Crop Yield Prediction System

A full-stack Machine Learning application that predicts agricultural crop yield using a Linear Regression model. The system consists of:

- 🤖 A Machine Learning model built with Scikit-learn
- 🚀 A FastAPI REST API
- 📱 A Flutter mobile application
- ☁️ Deployment on Render

---

## Project Overview

This project predicts crop yield based on historical agricultural data. Users provide information such as:

- Area
- Crop
- Year
- Average Rainfall
- Pesticide Usage
- Average Temperature

The trained machine learning model predicts the expected crop yield.

The project also supports retraining the model by uploading new agricultural datasets through the API.

---

## Technologies Used

### Machine Learning

- Python
- Pandas
- NumPy
- Scikit-learn
- Joblib

### Backend

- FastAPI
- Uvicorn
- Pydantic

### Mobile App

- Flutter
- Dart
- HTTP Package

### Deployment

- GitHub
- Render

---

## Project Structure

```
linear_regression_model/
│
├── summative/
│   ├── API/
│   │   ├── app/
│   │   ├── routers/
│   │   ├── data/
│   │   ├── model.py
│   │   ├── prediction.py
│   │   ├── train.py
│   │   └── main.py
│   ├── linear_regression/
│   │   ├── multivariate.ipynb
│   │   ├── best_model.pkl
│   │   └── yield_df.csv
│   └── FlutterApp/
├── README.md
└── requirements.txt
```

---

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/primitivecodes/linear_regression_model.git
cd linear_regression_model
```

### 2. Create a virtual environment

Windows:

```bash
python -m venv venv
venv\Scripts\activate
```

### 3. Install dependencies

```bash
pip install -r requirements.txt
```

### 4. Run the API

```bash
cd summative/API
python -m uvicorn app.main:app --reload
```

The server runs at `http://127.0.0.1:8000`. Swagger documentation is available at `http://127.0.0.1:8000/docs`.

---

## Running the Flutter App

```bash
cd summative/FlutterApp
flutter pub get
flutter run
```

---

## Live Deployment

- Render API: https://linear-regression-model-y3qw.onrender.com
- Swagger Documentation: https://linear-regression-model-y3qw.onrender.com/docs

---

## API Endpoints

### Home

`GET /`

```json
{
  "message": "Crop Yield Prediction API",
  "docs": "/docs"
}
```

### Predict Crop Yield

`POST /predict`

Example request:

```json
{
  "Area": "Rwanda",
  "Item": "Maize",
  "Year": 2013,
  "average_rain_fall_mm_per_year": 1200,
  "pesticides_tonnes": 3500,
  "avg_temp": 22.5
}
```

Example response:

```json
{
  "predicted_yield": 16641.86
}
```

### Retrain Model

`POST /retrain`

Upload `yield_df.csv`.

```json
{
  "message": "Model retrained successfully.",
  "records_added": 28242
}
```

---

## Demo Video

[![Crop Yield Prediction Demo](https://img.youtube.com/vi/CgwZJUYmmlQ/0.jpg)](https://youtu.be/CgwZJUYmmlQ)

---

## Screenshots

### Flutter Mobile App

`images/flutter_home.png`

### Prediction Result

`images/prediction.png`

### Swagger API

`images/swagger.png`

### Retraining Endpoint

`images/retrain.png`

---

## Machine Learning Workflow

1. Load dataset
2. Clean data
3. Encode categorical variables
4. Split training/testing data
5. Train Linear Regression model
6. Evaluate model
7. Save model using Joblib
8. Load model in FastAPI
9. Predict crop yield
10. Retrain model with uploaded dataset

---

## Features

✅ Crop Yield Prediction

✅ Machine Learning Model

✅ FastAPI REST API

✅ Input Validation

✅ Swagger Documentation

✅ CSV Upload

✅ Model Retraining

✅ Flutter Mobile Application

✅ Cloud Deployment on Render

---

## Future Improvements

- Authentication
- User Accounts
- Prediction History
- Model Versioning
- Charts and Analytics
- Multiple Machine Learning Algorithms
- Database Integration

---

## Author

**Premier Ufitinema**  
Bachelor of Software Engineering  
African Leadership University

GitHub: https://github.com/primitivecodes

---

## License

This project is for educational purposes.
