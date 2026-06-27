# Stage 18.1 plotting helper audit

Stage 18.1 reviewed the plotting-related internals after the optional plotting-engine work. The goal was to identify duplication and make only safe, behaviour-preserving cleanup.

## Files inspected

- `R/normcheck.R`
- `R/eovcheck.R`
- `R/modelcheck.R`
- `R/pairs20x.R`
- `R/model-diagnostic-helpers.R`
- `R/graphics-parameter-helpers.R`

## Findings

- Optional engine package checks were duplicated across `normcheck()`, `eovcheck()`, `modelcheck()`, and `pairs20x()`.
- Residual/fitted extraction already has a shared helper in `getModelResidualFittedData()`, which is used by the ggplot2 residual diagnostics.
- Base graphics parameter restoration already has shared helper support in `graphics-parameter-helpers.R`.
- The remaining ggplot2 panel-building code still repeats `getExportedValue()` assignments, but that code is close to each plot's drawing logic and was left unchanged for this audit stage.
- Engine dispatch remains deliberately explicit in each exported function so the base graphics default is easy to see and preserve.

## Stage 18.1 cleanup

- Added `requirePlottingPackage()` as a small internal helper for optional plotting package checks.
- Replaced repeated ggplot2/GGally availability checks with the helper.
- Preserved the existing optional dependency behavior and error wording.
- Made no user-facing plotting changes.

## Deferred cleanup candidates

- Consider a small exported-value helper only if a later stage changes several ggplot2 panels at once.
- Consider shared residual-plot data-frame construction for eovcheck/modelcheck only if the next stage touches both functions.
- Keep base graphics layout and teaching-oriented output unchanged unless a specific bug fix requires otherwise.
