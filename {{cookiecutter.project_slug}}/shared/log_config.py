from nano_shared.logger_configuration.log_utils import config_otel_logger
from nano_shared.logger_configuration.log_utils import log_config as log_config_base
from nano_shared.logger_configuration.log_utils import merge_dicts_recursive

from config import get_settings

settings = get_settings()


log_config = config_otel_logger(
    merge_dicts_recursive(
        log_config_base,
        {
            "loggers": {
                "uvicorn.error": {
                    "level": "ERROR",
                },
            }
        },
    )
)

log_config = config_otel_logger(log_config_base)
