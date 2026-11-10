---
name: classifiers
description: Use when a task applies the same choice, bool, or score question to many items, such as triage, filtering, labeling, or flagging. Covers discovering classifiers (local llama.cpp and microsoft-decision-1) in codemode, calling models.classify(), and falling back when they are unavailable.
---

# Classifiers

- Prefer decision models (classifiers) when a task applies the same choice, bool, or score question to many items, such as triage, filtering, labeling, or flagging.
- Check availability in `codemode` with `models.getAvailableOfType("classifier")`.
- Prefer models from the `llama.cpp` provider. They run locally and cost nothing.
- If no `llama.cpp` model is listed, check whether the llama.cpp server is running (`curl -s ${LLAMA_BASE_URL:-http://127.0.0.1:8080}/health`) and tell the user if it is down.
- If the local model is unavailable, use `microsoft-decision-1` from the `github-copilot` provider as the fallback.
- `microsoft-decision-1` has a per-input cost. Before you run it on a large batch, tell the user the item count and the cost from the model's `cost` field.
- Use `models.classify()` and check `stopReason` on every result. If calls fail on all available models, tell the user and do the task yourself.
