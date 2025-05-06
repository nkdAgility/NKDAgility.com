from fastapi import FastAPI, Request
import tiktoken
import uvicorn
import asyncio
import threading
import time

app = FastAPI()
encoding = tiktoken.get_encoding("cl100k_base")

# Track last request time
last_request_time = time.time()
shutdown_timeout = 60  # seconds

@app.post("/count-tokens")
async def count_tokens(request: Request):
    global last_request_time
    last_request_time = time.time()

    data = await request.json()
    content = data.get("content", "")
    tokens = encoding.encode(content)
    return {"token_count": len(tokens)}

def shutdown_monitor():
    global last_request_time
    while True:
        time.sleep(1)
        if time.time() - last_request_time > shutdown_timeout:
            print(f"No requests in {shutdown_timeout} seconds. Shutting down server.")
            asyncio.run(shutdown_server())
            break

async def shutdown_server():
    # This triggers FastAPI's shutdown
    import sys
    sys.exit(0)

if __name__ == "__main__":
    monitor_thread = threading.Thread(target=shutdown_monitor, daemon=True)
    monitor_thread.start()
    uvicorn.run(app, host="127.0.0.1", port=8000)
