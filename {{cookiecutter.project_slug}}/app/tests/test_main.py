from fastapi import status
from starlette.testclient import TestClient


def test_health(client: TestClient):
    response = client.get("/health")
    assert response.status_code == status.HTTP_200_OK
