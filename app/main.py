"""FastAPI application that serves predictions from the iris model."""

from fastapi import FastAPI
from pydantic import BaseModel, Field
from app.model import IrisClassifier

app = FastAPI(title="Iris Classifier API")

classifier = IrisClassifier()

class IrisFeatures(BaseModel):
    sepal_length: float = Field(..., example=5.1)
    sepal_width: float = Field(..., example=3.5)
    petal_length: float = Field(..., example=1.4)
    petal_width: float = Field(..., example=0.2)

@app.get("/health")
def health():
    return {"status": "ok"}

@app.post("/predict")
def predict(features: IrisFeatures):
    result = classifier.predict([
        features.sepal_length,
        features.sepal_width,
        features.petal_length,
        features.petal_width,
    ])
    return result