from fastapi import FastAPI


def create_app() -> FastAPI:
    return FastAPI()


app = create_app()


@app.get("/health")
def healthcheck():
    return {"status": "ok"}


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)  # nosec B104
