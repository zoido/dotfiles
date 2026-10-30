---
name: local-classifiers
description: Use when a task applies the same choice, bool, or score question to many items, such as triage, filtering, labeling, or flagging. Covers discovering local llama.cpp classifiers in codemode, calling models.classify(), and falling back when they are unavailable.
---

# Local Classifiers

- Prefer local decision models (classifiers) when a task applies the same choice, bool, or score question to many items, such as triage, filtering, labeling, or flagging.
- Check availability in `codemode` with `models.getAvailableOfType("classifier")` and prefer models from the `llama.cpp` provider.
- If none are listed, check whether the llama.cpp server is running (`curl -s ${LLAMA_BASE_URL:-http://127.0.0.1:8080}/health`) and tell the user if it is down.
- Use `models.classify()` and check `stopReason` on every result; if calls fail, tell the user and do the task yourself.
