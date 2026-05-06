# Stage 13 prediction-wrapper internal audit

## Scope

Stage 13.1 reviewed the internal structure of the current prediction teaching wrappers:

- `predict20x()`
- `predictGLM()`
- `predictCount()`
- shared helpers in `R/internal-predict-helper.R`
- prediction-wrapper tests in `tests/testthat/`

This stage is audit-only. It records focused maintenance targets for later Stage 13 sub-stages and does not redesign public APIs, rename exported functions, remove compatibility aliases, or intentionally alter user-visible teaching output.

## Current structure

The Stage 11 groundwork is present. The wrappers already call shared internal helpers for base prediction calls and interval arithmetic:

- `predictLmWithSe()` wraps `predict.lm(..., se.fit = TRUE)`.
- `predictGlmWithSe()` wraps `predict.glm(..., se.fit = TRUE)`.
- `predictionIntervalPercent()` centralises the upper-tail interval probability.
- `predictionConfidenceLimits()` centralises symmetric lower and upper interval arithmetic.
- `lmTeachingPredictionIntervals()` centralises linear-model confidence and prediction interval calculations.
- `glmTeachingConfidenceIntervals()` centralises GLM confidence interval calculations.
- `glmTeachingIntervalQuantile()` centralises normal versus quasi-model t quantile selection.

The current tests document return shapes, interval semantics, response-scale transformation, and compatibility with the shared helper path.

## Keep unchanged

These behaviours should remain stable unless a later sub-stage makes a small, deliberate, tested change:

- `predict20x()` invisibly returns a list with `frame`, `fit`, `se.fit`, `residual.scale`, `df`, and `cilevel`.
- `predictCount()` invisibly returns the rounded response-scale data frame.
- `predictGLM()` returns a matrix with `fit`, `lwr`, and `upr` columns.
- Existing column names with leading spaces are compatibility-sensitive and should not be renamed casually.
- Existing teaching-wrapper messages and printed output should not be changed incidentally.
- `predict20x()` and `predictCount()` currently impose stricter `newdata` shape expectations than base prediction methods. This is documented as compatibility behaviour.
- `predictGLM()` currently accepts log and logit links and treats all other links as unsupported.

## Consolidate duplicated helper logic

Possible narrow improvements for later stages:

- Extract common `newdata` data-frame validation to a small internal helper.
- Extract row-name construction for prediction rows.
- Consider a helper for legacy column-name derivation used by `predict20x()` and `predictCount()`.
- Consider a helper that assembles rounded teaching-output data frames while preserving legacy column names.

Any consolidation should be covered by regression tests that compare current outputs before and after the internal change.

## Clarify internal naming

Possible internal-only naming improvements:

- Normalise mixed local names such as `name.row`, `nameRow`, and `rowNames` when the surrounding code is touched.
- Prefer names that distinguish link-scale quantities from response-scale quantities in GLM wrappers.
- Remove or fix unused local assignments only when doing so is covered by tests and does not affect output.

These should remain internal naming changes only and should not rename exported functions or documented arguments.

## Add targeted regression tests

Potential tests for later sub-stages:

- `predictGLM()` should keep legacy handling of unsupported `type` values unless a deliberate compatibility decision is made.
- `predictGLM()` should keep current first-order `newdata` validation semantics for interaction or transformed-term models.
- `predict20x()` and `predictCount()` should preserve legacy column names and row names for multi-row `newdata`.
- Factor-predictor examples should preserve current data-frame column coercion and naming behaviour.
- Quasi-model interval quantile behaviour should remain covered for `quasit = TRUE` and should also document `quasit = FALSE`.

## Defer because behaviour/API risk is too high

The following are not suitable as incidental Stage 13 changes:

- Replacing these teaching wrappers with ordinary `predict()` interfaces.
- Changing return classes, visibility, column names, or rounding rules.
- Removing support for legacy `newdata` order and naming assumptions.
- Broadly changing `predictGLM()` link support.
- Changing printed messages or teaching output without an explicit user-visible decision.

## Recommended next sub-stage

Stage 13.2 should choose one narrow internal improvement. The safest first implementation target is likely common `newdata` data-frame validation, because it can remove repeated checks while preserving all current output and error text.

A slightly larger but still reasonable target is consolidating the legacy prediction-row naming logic across `predict20x()` and `predictCount()`. That should include multi-row regression tests before changing internals.
