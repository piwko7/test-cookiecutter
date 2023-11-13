from functools import lru_cache
from typing import TYPE_CHECKING

from pydantic import BaseSettings

if TYPE_CHECKING:
    from opentelemetry.sdk.resources import Resource


class Settings(BaseSettings):
    applicationinsights_connection_string: str = ""
    external_lib_level: str = "WARNING"
    rollbar_access_token: str
    rollbar_environment: str = ""
    rollbar_logger_level: str = "ERROR"

    @property
    def otel_resource(self) -> "Resource":
        from opentelemetry.sdk.resources import Resource

        resource = Resource.create(
            {
                "service.name": self.website_site_name,
                "service.instance.id": self.website_instance_id,
            },
        )
        return resource

    class Config:
        env_file = ".env"


@lru_cache
def get_settings() -> Settings:
    return Settings()
