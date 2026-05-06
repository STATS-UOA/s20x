# s20x Stage 12 chat context

## Purpose of the new chat

Continue the staged modernisation of the `s20x` package in a new chat, beginning with Stage 12.

Stage 12 should focus on documentation coherence, examples, and teaching narrative. It should not become a broad behavioural refactor.

## Current project state

Stages completed in the previous chat:

- Stage 9: package infrastructure.
- Stage 10: style normalisation.
- Stage 11: API consistency, prediction-wrapper audit/refactor groundwork, return-convention documentation/tests, and developer notes.

The latest completed stage is:

```text
Stage 11.17
```

The user has a compact bundle from Stage 11.17:

```text
11.17_chatgpt_bundle_20260506-111250.zip
```

For Stage 12 implementation work, ask for the full completed archive if needed:

```text
stage11_17_completed.zip
```

## Stage 12 scope

Stage 12 is documentation coherence.

Primary goals:

1. Review examples across help files.
2. Prefer actual `s20x` teaching datasets over generic datasets where appropriate.
3. Remove or replace misleading examples, especially examples that pretend non-time-series data are time series.
4. Make examples fast, deterministic, and suitable for `R CMD check`.
5. Clarify differences between ordinary linear model behaviour and specialised teaching wrappers or AR-error modelling helpers.
6. Keep behavioural changes out of scope unless a documentation problem exposes a small, obvious bug.

## Recommended Stage 12 sub-stage plan

Use planned sub-stage numbering:

```text
12.1, 12.2, 12.3, ...
```

Use error-fix numbering only when a planned sub-stage fails and needs repair:

```text
12.1.1, 12.1.2, ...
```

Recommended start:

### Stage 12.1: documentation audit

Create or update a tracked developer note, for example:

```text
inst/developer-notes/stage12-documentation-audit.md
```

This should review help examples and documentation issues, categorising candidates as:

- keep unchanged
- clarify wording
- replace example dataset
- make example safer/faster for `R CMD check`
- defer to deeper refactor stage

Avoid public API or behaviour changes in 12.1.

### Stage 12.2 and later

Implement one small documentation improvement at a time. Prefer a narrow group of related help files rather than package-wide rewriting.

Possible targets:

- prediction helper documentation and examples
- summary teaching helper documentation and examples
- case-study helper documentation
- diagnostic plotting helper documentation
- time-series or AR-error examples, if present

## Workflow and artifacts

For each planned Stage 12 sub-stage, provide only these two files:

```text
s20x_stage12_1_changes.zip
run_s20x_stage12_1.sh
```

Do not also provide `run_stage12_1.sh`. The user has a generic helper:

```bash
scripts/runStage.sh 12_1
```

The run script should:

1. optionally install the change-set zip
2. run `devtools::document()` with warnings as errors
3. run strict tests
4. run strict check
5. bump `DESCRIPTION` only after checks pass
6. commit with a focused ASCII commit message
7. create `stage12_1_completed.zip` using `git archive`, not `zip .`
8. build the package and capture the exact built tarball path
9. install that exact built package
10. create the compact ChatGPT bundle if `scripts/makeChatgptBundle.R` is available

Important archive rule:

Use `git archive` for completed zips. Do not use `zip -qr stageN_completed.zip .`, because that previously caused recursive inclusion of old completed zips and huge archives.

## Branch and repository notes

The user is working in the existing `s20x` repository, not a new package.

The active branch used during this stream is:

```text
feature-modernisation-plan
```

Do not assume the script should create or check out a branch. Stage scripts should be branch-agnostic and commit to the currently checked-out branch.

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

In recent stages, `NEWS.md` has been updated to the expected post-stage version number before the script bump. Continue that pattern.

Latest known Stage 11.17 NEWS/version context:

```text
Stage 11.17 updated NEWS.md to 3.2.250
```

The next planned stage should likely update NEWS to the next post-stage version, unless the current uploaded package shows a different version.

Always inspect the current `DESCRIPTION` and `NEWS.md` from the uploaded archive before deciding the exact NEWS heading.

## Stage 11 summary for continuity

Stage 11 established these decisions:

- Keep teaching wrappers as teaching wrappers rather than forcing them to mimic base R exactly.
- Preserve exported function names and compatibility aliases.
- Prediction wrappers were reviewed and documented as teaching wrappers.
- Shared internal prediction and interval helper groundwork was introduced.
- Return conventions were documented and regression-tested for several teaching-output functions.
- Deeper internal refactors and formal deprecations were deferred to later stages.
- Stage 12 should focus on documentation coherence rather than API redesign.

## File and upload expectations

At the start of the new chat, upload either:

```text
stage11_17_completed.zip
```

or, if only the compact bundle is available:

```text
11.17_chatgpt_bundle_20260506-111250.zip
```

For implementation work, the full completed archive is preferred.

## Preferred response pattern

For each stage, provide:

- a short change-notes section
- the two artifact links
- the run command

Example:

```text
Stage 12.1 is ready.

Files:

- s20x_stage12_1_changes.zip
- run_s20x_stage12_1.sh

Run:

scripts/runStage.sh 12_1
```

Keep stage commit messages focused on the current planned sub-stage. Only accumulate commit-message history across error-fix iterations such as `12.1.1` and `12.1.2`, not across completed planned stages like `12.1` and `12.2`.
