# s20x Stage 13 chat context

## Purpose of the new chat

Continue the staged modernisation of the `s20x` package in a new chat, beginning with Stage 13.

Stage 12 has completed the documentation coherence stream. Stage 13 should focus on targeted internal maintenance, starting with prediction-wrapper internals. It should not become a broad API redesign.

## Current project state

Stages completed in the previous chat:

- Stage 9: package infrastructure.
- Stage 10: style normalisation.
- Stage 11: API consistency, prediction-wrapper audit/refactor groundwork, return-convention documentation/tests, and developer notes.
- Stage 12: documentation coherence, examples, teaching narrative, NZ English, and final documentation wrap-up.

The latest completed stage is:

```text
Stage 12.10
```

At the end of Stage 12.10, the current stream was ready to merge `feature-modernisation-plan` into `master`, then begin the next feature branch:

```text
predict-internal-audit
```

## Stage 12 completion summary

Stage 12 covered:

- A documentation audit note in `inst/developer-notes/stage12-documentation-audit.md`.
- Replacement of misleading or generic examples with teaching datasets where appropriate.
- Safer, deterministic examples suitable for strict checks.
- Clarification of teaching wrappers versus ordinary base R behaviour.
- Clarification of prediction helper documentation.
- Clarification of AR-error modelling helper wording.
- Guarding of optional-package examples.
- Strict NZ English and grammar normalisation in documentation.
- Support for `"normalised"` as a package-facing spelling where `"normalized"` had been accepted, while preserving backward compatibility.
- Final Stage 12 completion notes and deferrals.

Stage 12 deliberately avoided broad behavioural refactors.

## Recommended Stage 13 scope

Stage 13 should focus on targeted internal refactor and maintenance.

Recommended start:

### Stage 13.1: prediction-wrapper internal audit

Create or update a tracked developer note, for example:

```text
inst/developer-notes/stage13-prediction-internal-audit.md
```

The audit should review the internals of:

- `predict20x()`
- `predictGLM()`
- `predictCount()`
- shared prediction interval helpers introduced or clarified in Stage 11
- related tests documenting return conventions and compatibility expectations

Stage 13.1 should be audit-only unless a tiny obvious issue is discovered while reading.

Suggested audit categories:

- keep unchanged
- consolidate duplicated helper logic
- clarify internal naming
- add targeted regression tests
- defer because behaviour/API risk is too high

### Stage 13.2 and later

Implement one narrow prediction-wrapper internal improvement at a time. Prefer small, reviewable changes over broad rewrites.

Possible later targets:

- common `newdata` validation or coercion helpers
- common interval-output formatting helpers
- consistent compatibility handling across prediction wrappers
- tests for shared internals and legacy behaviours
- diagnostic helper internals only after prediction wrappers are stable

## Explicit Stage 13 boundaries

Do not:

- redesign public APIs
- rename exported functions
- remove compatibility aliases
- alter user-visible teaching output unless the change is intentional and tested
- introduce large diagnostic plotting refactors before prediction internals are audited
- manually edit `NAMESPACE`; rely on roxygen2

Behaviour changes should be small, deliberate, backward-compatible where possible, and covered by tests.

## Workflow and artifacts

Continue the staged workflow.

For each planned Stage 13 sub-stage, provide only these two files:

```text
s20x_stage13_1_changes.zip
run_s20x_stage13_1.sh
```

Do not also provide alternate run-script names.

The user has a generic helper:

```bash
scripts/runStage.sh 13_1
```

The run script should:

1. optionally install the change-set zip
2. run `devtools::document()` with warnings as errors
3. run strict tests
4. run strict check
5. bump `DESCRIPTION` only after checks pass
6. commit with a focused ASCII commit message
7. create `stage13_1_completed.zip` using `git archive`, not `zip .`
8. build the package and capture the exact built tarball path
9. install that exact built package
10. create the compact ChatGPT bundle if `scripts/makeChatgptBundle.R` is available

Important archive rule:

Use `git archive` for completed zips. Do not use `zip -qr stageN_completed.zip .`, because that can recursively include old completed zips and huge archives.

## Script portability note

Generated scripts must be Windows/Git Bash-safe.

Avoid:

- Python for zip validation or extraction
- BSD-only `stat -f`
- commands that assume macOS-only behaviour

Use Rscript or portable shell where needed.

## Branch and repository notes

The previous working branch was:

```text
feature-modernisation-plan
```

After merging, the next branch should be:

```text
predict-internal-audit
```

Do not assume a stage script should create or check out a branch. Stage scripts should be branch-agnostic and commit to the currently checked-out branch.

## James's R development conventions

Use the user's `r-development-style` skill.

Key conventions:

- Use `=` for assignment, not `<-`.
- Use camelCase identifiers for new or touched code.
- Use styleR-style formatting.
- Always use braces for control structures, even single-line branches.
- Use the native pipe `|>` where useful, not magrittr.
- Keep changes targeted.
- Do not manually edit `NAMESPACE`; rely on roxygen2.
- Prefer `@importFrom` in roxygen documentation where imports are needed.
- Tests should be deterministic, offline, and fast.
- Preserve backward compatibility unless there is a strong reason not to.

## Developer notes location

Use tracked developer notes here:

```text
inst/developer-notes/
```

The repository should include this `.Rbuildignore` entry so developer notes do not enter package builds:

```text
^inst/developer-notes$
```

Do not use `dev/` for tracked notes because `dev/` is ignored in this repository.

## NEWS and versioning convention

Each stage script bumps `DESCRIPTION` after checks pass.

Continue the recent pattern:

- update `NEWS.md` to the expected post-stage version before the script bump
- inspect the current `DESCRIPTION` and `NEWS.md` from the uploaded archive before deciding the exact NEWS heading

The next planned stage should likely update NEWS to the next post-stage version, unless the current uploaded package shows a different version.

## Preferred response pattern

For each stage, provide:

- a short change-notes section
- the two artifact links
- the run command

Example:

```text
Stage 13.1 is ready.

Files:

- s20x_stage13_1_changes.zip
- run_s20x_stage13_1.sh

Run:

scripts/runStage.sh 13_1
```

Keep stage commit messages focused on the current planned sub-stage. Only accumulate commit-message history across error-fix iterations such as `13.1.1` and `13.1.2`, not across completed planned stages like `13.1` and `13.2`.
