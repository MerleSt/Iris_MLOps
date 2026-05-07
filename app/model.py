"""Loads the trained iris model and exposes a prediction function."""

import joblib
from pathlib import Path

MODEL_PATH = Path("model.joblib")

class IrisClassifier:
    def __init__(self, model_path: Path = MODEL_PATH):
        artifact = joblib.load(model_path)
        self.model = artifact["model"]
        self.target_names = artifact["target_names"]

    def predict(self, features: list[float]) -> dict:
        prediction = self.model.predict([features])[0]
        probabilities = self.model.predict_proba([features])[0]
        return {
            "predicted_class": self.target_names[prediction],
            "probabilities": {
                name: float(prob)
                for name, prob in zip(self.target_names, probabilities)
            }
        }