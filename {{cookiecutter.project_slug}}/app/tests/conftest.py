from fastapi.testclient import TestClient
import pytest

from config import get_settings


from main import create_app

settings = get_settings()


@pytest.fixture
def app():
    settings.applicationinsights_connection_string = ""
    app = create_app(settings)

    return app


@pytest.fixture
def client(app):
    with TestClient(app) as test_client:
        yield test_client
