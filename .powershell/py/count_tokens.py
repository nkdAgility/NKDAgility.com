import sys
import tiktoken
import json

encoding = tiktoken.get_encoding("cl100k_base")
results = []

for line in sys.stdin:
    text = line.strip()
    if text:
        tokens = encoding.encode(text)
        results.append(len(tokens))
    else:
        results.append(0)

print(json.dumps(results))
