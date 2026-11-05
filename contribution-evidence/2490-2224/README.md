# LLM4S issues #2490 and #2224 — validated contributions

Both implementations are published on XVSHIFU's fork. They have not yet been submitted as upstream PRs: each new contribution needs the human contributor's personal DCO sign-off.

Base commit: `58440eb921b9fcefb17c770616362e5ac00bde6a`.

| Issue | Branch | New tests | RAG regression | Diff |
| --- | --- | --- | --- | --- |
| [#2490](https://github.com/llm4s/llm4s/issues/2490) | test/2490-rag-query-transformers | 7 passed | 2,151 passed, 123 suites | one new file, +134/-0 |
| [#2224](https://github.com/llm4s/llm4s/issues/2224) | test/2224-ragas-langfuse-observer | 10 passed | 2,154 passed, 123 suites | one new file, +199/-0 |

Both RAG runs have one existing canceled experimental-stub test and one existing pending document/chunk-ID limitation test. Full repository `sbt test` was not run. The new tests are offline and deterministic; no production source changes remain.

For each branch, `sbt scalafmtAll`, `sbt scalafixAll`, `sbt scalafmtCheckAll`, and whitespace checks passed. Independent review found no blockers.

## Mutation checks

- #2490: making `applyQueryTransforms` always return `Right(query)` produces 3 expected failures and 4 passes.
- #2224: changing the detail limit from 50 to 51 produces 3 expected failures and 7 passes.
- Production source was restored byte-for-byte before the successful RAG regression runs.

Environment: Linux, full Temurin 21.0.13+9, sbt 1.12.12, Scala 3.7.1. An initial Maven Central HTTP 429 was resolved by reducing download concurrency; the reported passing results are from the successful runs.

## Exact published versions

| Issue | Unsigned commit | Tested tree |
| --- | --- | --- |
| #2490 | fd422ea441c4d0bcf4c03e038352cf7849f296bd | 770fea63872797495408a927e567fdb1417b1c1f |
| #2224 | aba6d5f057034da8a0496107ba01f3e52bb7997e | 5f3cb6d810862f701a6444b7505624959d0e9504 |

The commit messages explain the changes and reference their issues. The PR descriptions are prepared in `2490-PR-body.md` and `2224-PR-body.md`.

## Personal DCO step

[CLAUDE.md](https://github.com/llm4s/llm4s/blob/main/CLAUDE.md#commits) requires a real person's sign-off and says it cannot be added on someone else's behalf. Review the two diffs and the [DCO](https://developercertificate.org/) before personally running `llm4s-signoff.ps1`.

The helper supports Windows PowerShell 5.1 and PowerShell 7. Download/open it, review it, and paste its contents into your terminal. It uses your existing Git name/email, creates two separate checkout-free clones, populates their index with `git read-tree HEAD`, amends each commit with your sign-off, verifies tree and parent preservation, then pushes the intended branch using an exact SHA lease. It stops on errors or unexpected branch changes.

The checkout-free signoff flow was verified in an isolated local test repository using a dummy identity; no real contribution was signed by the assistant.

After the human sign-off, verify each remote head has the expected tree, original parent, and a Signed-off-by trailer matching its author. Then check the PR draft's sign-off box and submit each contribution separately to upstream main. Do not submit this evidence branch as a PR.
