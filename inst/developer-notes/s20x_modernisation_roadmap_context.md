# s20x modernisation roadmap context

## Purpose

This file records the agreed roadmap for modernising the `s20x` package after the `tslm()` staged work. The modernisation should stay inside the existing `s20x` repository rather than becoming a new project.

## Guiding principle

Modernise the package incrementally. Each stage should be small, testable, reversible, and easy to review.

Avoid a whole-package rewrite. Do not reformat or redesign the whole package at once.

## Why this stays in `s20x`

- Existing teaching material, datasets, examples, and users already depend on `s20x`.
- A new package would create a forked ecosystem and make maintenance harder.
- The staged workflow is already working well for controlled package evolution.
- CRAN-style package maintenance normally favours gradual in-place improvement with compatibility wrappers and deprecation where needed.

## Roadmap

### Stage 9: package infrastructure

Focus on project hygiene and reliability before deeper refactoring.

Likely tasks:

- Add GitHub Actions for `R CMD check`.
- Check current R release, old release, and devel where practical.
- Confirm `DESCRIPTION` metadata is current and consistent.
- Add or tidy `NEWS.md` if needed.
- Keep the package passing strict local checks.

### Stage 10: style normalisation

Apply James's preferred style gradually to touched files only.

Style rules:

- Use `=` for assignment, not `<-`.
- Use camelCase identifiers for new or touched code.
- Use braces for all control structures.
- Prefer native pipes only where useful.
- Do not do a package-wide reformat unless explicitly planned as a separate mechanical stage.

### Stage 11: API consistency

Review user-facing functions for consistency and compatibility.

Possible tasks:

- Improve argument naming consistency.
- Check return object conventions.
- Strengthen `print()`, `summary()`, `plot()`, and other method behaviour.
- Preserve existing student-facing function names unless a compatibility wrapper is provided.
- Mark deprecated aliases explicitly rather than removing them abruptly.

### Stage 12: documentation coherence

Make documentation consistent with the modernised teaching narrative.

Possible tasks:

- Review examples across help files.
- Prefer actual `s20x` teaching datasets over generic datasets where appropriate.
- Remove misleading examples, especially examples that pretend non-time-series data are time series.
- Make examples fast, deterministic, and suitable for `R CMD check`.
- Clarify differences between ordinary linear model behaviour and specialised methods such as AR-error models.

### Stage 13 and later: deeper refactors

Only after infrastructure, examples, and documentation are stable.

Possible tasks:

- Extract internal helpers.
- Separate plotting, checking, and modelling responsibilities more clearly.
- Improve internal object design.
- Reduce duplicated code.
- Improve performance where it matters.

## Stage numbering convention

Use whole numbers for planned stages:

- `9`
- `10`
- `11`

Use one decimal for planned sub-stages:

- `9.1`
- `9.2`

Use deeper decimals only for error-fix iterations:

- `9.1.1`
- `9.1.2`

Filename convention uses underscores:

- `s20x_stage9_changes.zip`
- `run_s20x_stage9.sh`
- `s20x_stage9_1_changes.zip`
- `run_s20x_stage9_1.sh`
- `s20x_stage9_1_1_changes.zip`
- `run_s20x_stage9_1_1.sh`

## Practical workflow

Each stage should normally produce:

- a changes zip
- a run script
- a strict check workflow
- a version bump only after checks pass
- a git commit
- a completed archive
- an installed built tarball
- a compact ChatGPT bundle when available

## Current recommendation

Start the next chat with Stage 9: package infrastructure.

