---
name: classifiers
description: Use when a task applies the same choice, bool, or score question to many items, such as triage, filtering, labeling, or flagging, for example "which of these 50 issues are bugs", "go through all files and flag the ones that…", or "sort these into categories". Covers discovering classifiers (local llama.cpp and microsoft-decision-1) in codemode, calling models.classify(), and falling back when they are unavailable.
---

# Classifiers

Classifiers (decision models) answer typed questions about one item at a time. For many items they are faster and cheaper than reading each item yourself.

## Pick a model

- List the models in `codemode` with `models.getAvailableOfType("classifier")`.
- Prefer models from the `llama.cpp` provider. They run locally and cost nothing.
- If no `llama.cpp` model is listed, check whether the llama.cpp server is running (`curl -s ${LLAMA_BASE_URL:-http://127.0.0.1:8080}/health`) and tell the user if it is down.
- If the local model is unavailable, use `microsoft-decision-1` from the `github-copilot` provider as the fallback.
- `microsoft-decision-1` has a per-input cost. Before you run it on a large batch, tell the user the item count and the cost from the model's `cost` field.

## Classify

Call `models.classify()` once per item. One call can answer several questions about the same item. `Promise.all()` is fine, because codemode runs at most four calls at once. The full API is in `/opt/pi-coding-agent/docs/codemode.md`, section "Classify".

```js
const [model] = (await models.getAvailableOfType("classifier")).filter((m) => m.provider === "llama.cpp");
const results = await Promise.all(
  items.map((item) =>
    models.classify(model, {
      state: { title: item.title, body: item.body },
      questions: {
        bug: {
          type: "bool",
          instructions: "Does this issue report a bug?",
          criteria: { true: "Describes wrong behavior", false: "Feature request, question, or other" },
        },
      },
    }),
  ),
);
return results.map((r, i) =>
  r.stopReason === "stop" ? { id: items[i].id, bug: r.answers.bug.probability } : { id: items[i].id, error: r.errorMessage },
);
```

- `classify()` does not throw on provider errors. Check `stopReason` on every result.
- Write `criteria` that describe each answer clearly. The model judges against them, so vague criteria give random answers.
- Put only the fields that matter in `state`. Long, unrelated text makes the answers worse.

## Check the answers

- Read the items where the model is not sure (a `bool` probability near 0.5, or a low `confidence` for `choice` and `score`) and decide them yourself.
- Check a few confident answers too. If they are wrong, improve the criteria and run again.
- If calls fail on all available models, tell the user and do the task yourself.
