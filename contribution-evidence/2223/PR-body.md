## What does this PR do?

Add deterministic tests for `TestDataset.generateFromDocuments`, which was not covered by the existing dataset specs. A scripted LLM client exercises plain JSON, Markdown fences, surrounding prose, sample and dataset metadata, per-document failures, and prompt inputs.

This prevents parsing regressions from silently removing synthetic evaluation data. No production code changes.

Prepared with Codex assistance.

## Related issue

Fixes #2223.

## How was this tested?

On Linux, Temurin 21.0.13, sbt 1.12.12 and Scala 3.7.1:

- `sbt "rag/testOnly org.llm4s.rag.evaluation.TestDatasetGenerationSpec"` — all 8 tests passed.
- `sbt rag/test` — 2,144 passed; one existing experimental-stub test canceled and one existing known-limitation test pending.
- `sbt scalafmtAll`, `sbt scalafixAll`, and `sbt scalafmtCheckAll` — passed.
- Temporarily changed `extractJsonArray` to return its input unchanged: the fenced JSON and surrounding-prose cases failed as expected. Restored the source byte-for-byte, then ran the passing RAG suite.

The new tests require no API keys or external services. The full repository `sbt test` suite was not run.

## Checklist

- [x] I have read the [Contributing Guide](https://llm4s.org/reference/contributing)
- [x] PR is small and focused — one change, one reason
- [x] `sbt scalafixAll` passes
- [x] `sbt scalafmtAll` — code is formatted
- [ ] `sbt test` — tests pass on Scala 3 (RAG module tested; full repository suite not run)
- [x] New code includes tests
- [x] No unrelated changes included (branched from `main`, not from another PR)
- [x] Commit messages explain the "why"
- [ ] Every commit is signed off (`git commit -s`)
- Not applicable: public API, tier, SPI or wire-format RFC; tests only.
- Not applicable: changelog entry; no feature, bug fix or breaking change.
