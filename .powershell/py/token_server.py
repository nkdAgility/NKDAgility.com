# token_server.py
# Version: 1.1

from fastapi import FastAPI, Request
import tiktoken
import uvicorn

app = FastAPI()
encoding = tiktoken.get_encoding("cl100k_base")

@app.post("/count-tokens")
async def count_tokens(request: Request):
    data = await request.json()
    content = data.get("content", "")
    tokens = encoding.encode(content)
    return {"token_count": len(tokens)}

if __name__ == "__main__":
    # Run Uvicorn with reuse_port for safer restarts
    uvicorn.run(
        app,
        host="127.0.0.1",
        port=8000,
        log_level="info"
    )
