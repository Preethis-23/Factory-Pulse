from fastapi import FastAPI
app = FastAPI()
@app.get("/health")
def health():
    return {"service": "ingestion", "status": "ok", "version": "0.1.0-M1"}