import uvicorn
import sys


if __name__ == "__main__":

    port = 2096

    if "--port" in sys.argv:
        index = sys.argv.index("--port")
        port = int(sys.argv[index + 1])


    uvicorn.run(
        "app.main:app",
        host="0.0.0.0",
        port=port,
        reload=False
    )
