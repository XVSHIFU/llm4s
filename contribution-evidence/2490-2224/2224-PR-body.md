## What does this PR do?

Add deterministic tests for `RAGASLangfuseObserver` using a recording `LangfuseBatchSender`. The tests verify evaluation and summary event order, score values, trace reuse, input and metadata payloads, sender configuration, and the 50/500 UTF-16 truncation boundaries, including emoji pairs.

This protects the data exported to Langfuse against regressions without a Langfuse instance, API keys or network access. No production code changes.

Prepared with Codex assistance.

## Related issue

Fixes #2224.

## How was this tested?

- `sbt scalafmtAll` — passed; no unrelated tracked files changed.
- `sbt "rag/testOnly org.llm4s.rag.evaluation.RAGASLangfuseObserverSpec"` — all 10 tests passed.
- Required mutation check — temporarily increased the score-detail truncation limit from 50 to 51: the three detail-truncation tests failed as expected, with the other seven passing. Restored the production source byte-for-byte before the passing RAG regression run.
- `sbt rag/test` — 2,154 passed across 123 suites; one existing experimental-stub test canceled and one existing document/chunk-ID limitation test pending.
- `sbt scalafmtCheckAll` — passed.
- `sbt scalafixAll` — passed.
- Independent read-only review found no blockers.

Run on Linux with Temurin 21.0.13, sbt 1.12.12 and Scala 3.7.1. The full repository `sbt test` suite was not run.

## Checklist

- [x] I have read the [Contributing Guide](https://llm4s.org/reference/contributing)
- [x] PR is small and focused — one change, one reason
- [x] `sbt scalafixAll` passes
- [x] `sbt scalafmtAll` — code is formatted
- [ ] `sbt test` — tests pass on Scala 3
- [x] New code includes tests
- [x] No unrelated changes included (branched from `main`, not from another PR)
- [x] Commit messages explain the "why"
- [ ] Every commit is signed off (`git commit -s`)
- Not applicable: public API, tier, SPI or wire-format RFC; tests only.
- Not applicable: changelog entry; no feature, bug fix or breaking change.
