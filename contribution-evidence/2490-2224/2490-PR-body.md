## What does this PR do?

Add offline tests for RAGConfig's query-transformer methods and their integration with RAG.query. The tests pin ordered append, replacement, transformed embedding input, failure short-circuiting and the unchanged query path.

A recording embedding provider and in-memory stores also verify that rewriting a query changes which stored chunk is retrieved. The two-transformer case uses a noncommuting chain so reversing the order fails. No production code changes.

Prepared with Codex assistance.

## Related issue

Fixes #2490.

## How was this tested?

On Linux, Temurin 21.0.13, sbt 1.12.12 and Scala 3.7.1:

- `sbt "rag/testOnly org.llm4s.rag.RAGQueryTransformerSpec"` — all 7 tests passed.
- Temporarily made `applyQueryTransforms` return `Right(query)`: 3 expected failures and 4 passing tests. Restored the production source byte-for-byte before the passing RAG regression run.
- `sbt rag/test` — 2,151 passed across 123 suites; one existing experimental-stub test canceled and one existing document/chunk-ID limitation test pending.
- `sbt scalafmtAll`, `sbt scalafixAll`, `sbt scalafmtCheckAll` and `git diff --check` — passed.

No network, Docker, API keys or external services are required by the new tests. The full repository `sbt test` suite was not run.

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
