from fastapi import APIRouter, Response, status

health_router = APIRouter()


@health_router.get("/health")
def health():
    return Response(status_code=status.HTTP_200_OK)
