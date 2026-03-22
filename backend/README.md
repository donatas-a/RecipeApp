# FastAPI API Component

This folder contains a FastAPI implementation for the RecipeApp API requirements.

## Run locally

```bash
cd backend
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

## Test

```bash
cd backend
PYTHONPATH=. pytest
```
