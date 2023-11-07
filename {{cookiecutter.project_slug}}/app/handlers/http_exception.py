from typing import Any, Dict

from fastapi import Request, status
from fastapi.encoders import jsonable_encoder
from fastapi.responses import JSONResponse

RESOURCE_NOT_FOUND = "Resource was not found"


class CustomException(Exception):
    def __init__(self, status_code: int, content: Dict[str, Any]):
        self.status_code = status_code
        self.content = content


class NotFoundException(CustomException):
    def __init__(self, resource_id: str):
        self.status_code = status.HTTP_404_NOT_FOUND
        self.content = {
            "errorMessage": RESOURCE_NOT_FOUND,
            "resourceId": resource_id,
        }


class UnprocessableEntityException(CustomException):
    def __init__(self, msg: str, resource_id: str):
        self.status_code = status.HTTP_422_UNPROCESSABLE_ENTITY
        self.content = {
            "errorMessage": msg,
            "resourceId": resource_id,
        }


async def validation_exception_handler(request, exc):
    return JSONResponse(
        content=jsonable_encoder({"detail": exc.errors(), "body": exc.body}),
        status_code=status.HTTP_400_BAD_REQUEST,
    )


async def custom_exception_handler(request: Request, exception: CustomException):
    return JSONResponse(status_code=exception.status_code, content=exception.content)
