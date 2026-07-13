from contextlib import asynccontextmanager


@asynccontextmanager
async def lifespan(app):

    print("L-Panel Started")

    yield

    print("L-Panel Stopped")
