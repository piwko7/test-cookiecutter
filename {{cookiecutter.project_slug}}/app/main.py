from logging.config import dictConfig

from fastapi import FastAPI
from fastapi.exceptions import RequestValidationError
from nano_shared.logger_configuration.log_utils import (
    config_otel_logger,
    configure_logger,
    log_config,
)
from rollbar.contrib.fastapi import ReporterMiddleware as RollbarMiddleware

from config import get_settings

dictConfig(config_otel_logger(log_config))
settings = get_settings()

logger = configure_logger("main")


def create_app(settings=settings):
    app = FastAPI(title="Nanostore Bifrost")

    if settings.applicationinsights_connection_string:
        from nano_shared.tracing import configure_tracing

        configure_tracing(app=app)

    from dependencies import Container

    container = Container()
    container.config.from_pydantic(settings=settings)
    setattr(app, "container", container)

    if settings.rollbar_access_token:
        app.add_middleware(RollbarMiddleware)

    from routers.health import health_router

    app.include_router(health_router)

    from handlers.http_exception import (
        custom_exception_handler,
        CustomException,
        validation_exception_handler,
    )

    app.add_exception_handler(RequestValidationError, validation_exception_handler)
    app.add_exception_handler(CustomException, custom_exception_handler)

    container.wire()
    return app


if __name__ == "__main__":
    import argparse

    import uvicorn

    from validators import validate_ipv4_address, validate_port

    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--host",
        type=validate_ipv4_address,
        default="0.0.0.0",
        help="The host IP address (default: 0.0.0.0)",
    )
    parser.add_argument(
        "--port",
        type=validate_port,
        default=8000,
        help="The port number (default: 8000)",
    )

    args = parser.parse_args()

    uvicorn.run(
        app=create_app,
        host=args.host,
        port=args.port,
        factory=True,
    )
