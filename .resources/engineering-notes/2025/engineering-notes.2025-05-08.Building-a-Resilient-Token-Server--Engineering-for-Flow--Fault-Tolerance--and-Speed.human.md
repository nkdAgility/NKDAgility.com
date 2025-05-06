---
title: 'Building a Resilient Token Server: Engineering for Flow, Fault Tolerance, and Speed'
description: Discover how I engineered a resilient, fault-tolerant PowerShell + FastAPI system for fast, reliable OpenAI token counting—built to thrive under real-world load.
ResourceId: mjsboLP-N9P
ResourceImport: false
ResourceType: engineering-notes
ResourceContentOrigin: human
date: 2025-05-08T09:00:00Z
weight: 260
aliases:
- /resources/mjsboLP-N9P
categories:
- Engineering Excellence
- DevOps
tags:
- Pragmatic Thinking
- Software Development
- Technical Mastery
- Operational Practices
- Troubleshooting
- Personal
- Continuous Improvement
- Engineering Practices
- Working Software
- Technical Excellence
- Site Reliability Engineering
- System Configuration

---
Modern engineering is about making sure systems keep running reliably under load, failure, and unpredictable conditions. When I set out to build a fast, dependable way to calculate OpenAI token counts for my batch classification pipeline, I didn’t want a quick script or a one-off tool. I wanted a **resilient, observable, fault-tolerant system** that fit tightly into my PowerShell-first workflow and could hold up in real conditions, not just lab tests.

**Background:** Midway through last year, I finally accepted that WordPress was no longer the future for me. To be honest, I’d known it for a while, but the pain of migrating was bigger than the pain of sticking with it—until it wasn’t. I made the deliberate choice to rebuild a decade of Wordpress content into Hugo, Markdown, YAML, and a layer of PowerShell automation for bulk editing. As I ramped up automation for pre-processing and OpenAI-driven bulk edits, one bottleneck hit hard: counting tokens. I had an existing method calling out to Python from PowerShell, but it clocked in at around five minutes per thousand prompts. That was unacceptable for the scale I wanted.

This post lays out exactly how I tackled that challenge—what worked, what fell apart, and how I hardened the system into something that performs reliably under real-world pressure, or at least "my world" pressure.

## Starting Line: What I Set Out to Build

- A Python FastAPI server (`token_server.py`) to expose token counting as a REST API.
- A PowerShell wrapper (`TokenServer.ps1`) to orchestrate batch calls and control the server lifecycle.
- Seamless integration into our `Update-ResourcesClassificationsBatch.ps1` script, which feeds Hugo markdown files for token counting.

Sounds simple? Not so fast.

## Where It Fell Apart

Here’s where the early implementation hit the wall:

- Repeated server restarts led to **Windows port binding errors** (`Only one usage of each socket address...`).
- Sockets sat in `TIME_WAIT`, leaving the system **unable to reuse ports quickly**.
- PowerShell orchestration assumed the server was either always running or needed a restart; both assumptions failed under load. We were processing \~30k prompts, and it failed at about 6k.
- Failure detection (`Test-TokenServer`) was **too aggressive**, flagging false negatives and triggering unnecessary restarts.

In short, the system had no resilience. It worked when everything was perfect and collapsed under even minor hiccups. That’s not engineering; that’s gambling.

It did get to the end of its run, but the logs told the real story, which is why I included the relevant segment here. Logs are not fluff or noise; they are the raw, transparent evidence that shows what really happened, reinforcing my ethos of engineering honesty and accountability, even when things get messy. The real story of errors and flakiness:

```bash
[11:38:27 INF] Starting Token Server on 127.0.0.1:8000 using script .\.powershell\py\token_server.py
[11:38:37 INF] Token Server is now running at 127.0.0.1:8000
[11:38:41 INF] 1521 prompts Built for 9 of 169 markdown files (5%)
[11:38:48 INF] 2843 prompts Built for 17 of 169 markdown files (10%)
[11:38:54 INF] 4229 prompts Built for 26 of 169 markdown files (15%)
[11:39:01 INF] 5476 prompts Built for 34 of 169 markdown files (20%)
[11:39:09 INF] 6862 prompts Built for 43 of 169 markdown files (25%)
[11:39:18 INF] Token Server already responding at 127.0.0.1:8000
[11:39:18 ERR] Failed to get token count from server: Only one usage of each socket address (protocol/network address/port) is normally permitted. (127.0.0.1:8000)
[11:39:24 INF] Stopping Token Server with tracked PID 13536
[11:39:24 INF] Starting Token Server on 127.0.0.1:8000 using script .\.powershell\py\token_server.py
[11:39:25 INF] Token Server is now running at 127.0.0.1:8000
[11:39:25 ERR] Failed to get token count from server: Only one usage of each socket address (protocol/network address/port) is normally permitted. (127.0.0.1:8000)
[11:39:29 INF] Token Server already responding at 127.0.0.1:8000
[11:39:29 ERR] Failed to get token count from server: Only one usage of each socket address (protocol/network address/port) is normally permitted. (127.0.0.1:8000)
[11:39:32 INF] Token Server already responding at 127.0.0.1:8000
[11:39:32 ERR] Failed to get token count from server: Only one usage of each socket address (protocol/network address/port) is normally permitted. (127.0.0.1:8000)
[11:39:34 ERR] Failed to get token count from server: Only one usage of each socket address (protocol/network address/port) is normally permitted. (127.0.0.1:8000)
[11:39:40 INF] Stopping Token Server with tracked PID 121896
[11:39:40 INF] Starting Token Server on 127.0.0.1:8000 using script .\.powershell\py\token_server.py
[11:39:48 INF] Token Server is now running at 127.0.0.1:8000
[11:39:48 ERR] Failed to get token count from server: Only one usage of each socket address (protocol/network address/port) is normally permitted. (127.0.0.1:8000)
[11:39:53 INF] Token Server already responding at 127.0.0.1:8000
[11:39:54 ERR] Failed to get token count from server: Only one usage of each socket address (protocol/network address/port) is normally permitted. (127.0.0.1:8000)
[11:39:56 INF] 8094 prompts Built for 51 of 169 markdown files (30%)
[11:39:59 ERR] Failed to get token count from server: Only one usage of each socket address (protocol/network address/port) is normally permitted. (127.0.0.1:8000)
[11:40:01 ERR] Failed to get token count from server: Only one usage of each socket address (protocol/network address/port) is normally permitted. (127.0.0.1:8000)
[11:40:05 INF] Token Server already responding at 127.0.0.1:8000
[11:40:06 ERR] Failed to get token count from server: Only one usage of each socket address (protocol/network address/port) is normally permitted. (127.0.0.1:8000)
[11:40:12 INF] Stopping Token Server with tracked PID 234028
[11:40:12 INF] Starting Token Server on 127.0.0.1:8000 using script .\.powershell\py\token_server.py
[11:40:13 INF] Token Server is now running at 127.0.0.1:8000
[11:40:13 ERR] Failed to get token count from server: Only one usage of each socket address (protocol/network address/port) is normally permitted. (127.0.0.1:8000)
[11:40:13 ERR] Failed to get token count from server: Only one usage of each socket address (protocol/network address/port) is normally permitted. (127.0.0.1:8000)
[11:40:20 INF] Stopping Token Server with tracked PID 242448
[11:40:20 INF] Starting Token Server on 127.0.0.1:8000 using script .\.powershell\py\token_server.py
[11:40:21 INF] Token Server is now running at 127.0.0.1:8000
[11:40:27 INF] Stopping Token Server with tracked PID 232540
[11:40:27 INF] Starting Token Server on 127.0.0.1:8000 using script .\.powershell\py\token_server.py
[11:40:37 INF] Token Server is now running at 127.0.0.1:8000
[11:40:42 INF] 9480 prompts Built for 60 of 169 markdown files (35%)
[11:40:50 INF] 10712 prompts Built for 68 of 169 markdown files (40%)
```

This worked, but all the restarts made it painfully slow. However, to be clear, it was still faster than using local token calls.

## Refactoring for Resilience

Here’s exactly how I hardened the system once it was working, keeping everything pragmatic, outcome-focused, and fully aligned to the engineering ethos I follow — minimising errors, maximising resilience, and ensuring flow without cutting corners or adding unnecessary complexity.

### Start/Stop Once Per Batch

Originally, I tried a model of "start the server if it’s not running, and kill it if it faults," but that is what resulted in the errors above. Instead of cycling the server, I flipped to a **batch-wide lifecycle**:

```powershell
Start-TokenServer
# Process all files here...
Stop-TokenServer
```

This reduced port churn, avoided TIME_WAIT issues, and drastically simplified orchestration.

### Add Retries Instead of Restarts

From the log above, you can see I was trying to solve the fake-response problem by restarting the server — but that was the wrong approach. Restarting might hide symptoms, but it never fixes the underlying fragility. It always reminds me of that ridiculous video where someone rigged up a second server with a CD tray and taped a pencil to it so that when the first server stopped responding, the second one would eject its tray and physically press the reset button on the first. Sure, it technically works, but it’s the software equivalent of sweeping dirt under a rug. Engineering excellence means you address the real issues directly, not patch over them with hacks.

Inside `Get-TokenCountFromServer`, we wrapped the REST call in a retry loop:

```powershell
for ($i = 0; $i -lt 3; $i++) {
    try {
        $response = Invoke-RestMethod -Uri $ServerUrl -Method Post -Body $body -ContentType "application/json" -TimeoutSec 10
        return [int]$response.token_count
    }
    catch {
        Start-Sleep -Seconds 1
    }
}
```

This change turned transient network failures from system-breaking to non-events with barely noticeable delays. At scale, I would want proper back-off logic and probably apply a circuit breaker pattern, but here I kept it simple because it delivers what matters: stable, predictable flow without unnecessary overengineering.

### Implement Local Fallback

I already have logic to calculate the tokens locally and in isolation, which was the thing I wanted to refactor away. However, I realised that if the server was overloaded, I could either retry indefinitely, fail out, or regress to a local Python call. Sure, it was the slower path, but it acted as a deliberate, engineered fallback when the server stopped responding under load. This wasn’t just retries stacked on retries — it was a purposeful local option to guarantee the system would not fail completely and would keep moving, even if with a slight delay:

```powershell
function Get-TokenCountLocally {
    param ([string]$Content)

    $tempFile = [System.IO.Path]::GetTempFileName()
    Set-Content -Path $tempFile -Value $Content -Encoding UTF8

    $tokenCount = python -c @"
import tiktoken, sys
with open(sys.argv[1], 'r', encoding='utf-8') as f:
    text = f.read()
encoding = tiktoken.get_encoding('cl100k_base')
print(len(encoding.encode(text)))
"@ $tempFile

    Remove-Item $tempFile -Force
    return [int]$tokenCount
}
```

## Final System Outcomes

By the end, we delivered a system that:

- Survives server restarts and network hiccups.
- Automatically falls back to local processing if the server is down, giving it time to recover
- Handles high-volume batch loads without choking.
- Provides clear, observable logs for troubleshooting and improvement.

This is not just about counting tokens. It is about building resilient, fault-tolerant architectures that hold up under real-world use — and taking full ownership of the engineering outcome, even when the tool is 'just a script' for my own workflows. This reflects my principles as an engineer: if I touch it, I am accountable for its resilience, its clarity, and its long-term behaviour. And this is the work I put into a simple script that only I need to run. If this were going to be a production system, I'd have to take it to a whole other level, and I would expect engineering teams I work with to do the same.

I'm certainly not done, and the scripts I use get continuous refinement and are adapted as I learn more and need more. Here are some ideas for improvements:

Here’s what I’m noodling on next:

- **Separate concerns in PowerShell** — I already have reusable modules, but I can sharpen this by splitting orchestration logic and reusable functions into clean, distinct scripts or modules.
- **Use structured exceptions** — Plain error logs only get me so far; I want to move to proper PowerShell error records or thrown exceptions so failures are surfaced intentionally, not passively.
- **Add FastAPI health and version endpoints** — Lightweight /health and /version routes will let me run fast checks and diagnostics without poking deep into the server.
- **Introduce concurrency handling** — Adding PowerShell locking or a mutex will protect against race conditions if multiple scripts try to touch the server at once.
- **Dockerize the Python token server** — Packaging the server into a Docker container will give me environment isolation and smoother deployment, especially when moving between local and cloud setups.
- **Implement structured logging** — I want to replace Write-Host or Write-InfoLog with structured log outputs (like JSON or key-value pairs) so logs are machine-readable and easier to pipeline.
- **Write automated tests** — Pester for PowerShell unit tests and pytest with httpx for FastAPI endpoint testing will give me confidence this system holds up, even as I evolve and extend it.

But for now, I'm happy that it's executing and reasonably resilient. Next time I run it I might not feel the same and make more changes.

# Final Takeaway

Building resilient systems is not about making them work once. It is about making sure they keep working when the environment turns hostile. This mindset aligns directly with the DevOps ethos: accountability, continuous improvement, and designing systems that deliver reliable value no matter the noise or disruption. This Token Server journey was a microcosm of that challenge, and the lessons apply far beyond token counting.

- Design for failure.
- Build in observability.
- Create fallback paths.
- Prioritise flow, not brute-force restarts.
