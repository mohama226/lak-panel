import uvicorn

from app.core.config import settings
from app.core.ocserv_cache import OcservCache


if __name__ == "__main__":

    # Start ocserv cache worker
    OcservCache.start()

    uvicorn.run(
        "app.main:app",
        host=settings.APP_HOST,
        port=settings.APP_PORT,
        reload=False,
    )
