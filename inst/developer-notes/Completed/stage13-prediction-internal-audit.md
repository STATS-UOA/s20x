# Stage 13 prediction-wrapper internal audit

## Scope

Stage 13 reviewed and then narrowly maintained the internal structure of the current prediction teaching wrappers:

- `predict20x()`
- `predictGLM()`
- `predictCount()`
- shared helpers in `R/internal-predict-helper.R`
- prediction-wrapper tests in `tests/testthat/`

The stream deliberately avoided a broad public API redesign. It did not rename exported functions, remove compatibility aliases, or replace the teaching wrappers with ordinary base-R prediction interfaces.

## Current structure

The Stage 11 groundwork is present and Stage 13 has extended it. The wrappers now use shared internal helpers for base prediction calls, interval arithmetic, `newdata` validation, and interval-output assembly:

- `predictLmWithSe()` wraps `predict.lm(..., se.fit = TRUE)`.
- `predictGlmWithSe()` wraps `predict.glm(..., se.fit = TRUE)`.
- `validatePredictionNewdata()` centralises first-order `newdata` data-frame validation.
- `predictionIntervalPercent()` centralises the upper-tail interval probability.
- `predictionConfidenceLimits()` centralises symmetric lower and upper interval arithmetic.
- `formatPredictionIntervalFrame()` centralises interval data-frame assembly where wrappers return teaching output frames.
- `formatPredictionIntervalMatrix()` centralises interval matrix assembly where legacy internals still need matrix-shaped output.
- `lmTeachingPredictionIntervals()` centralises linear-model confidence and prediction interval calculations.
- `glmTeachingConfidenceIntervals()` centralises GLM confidence interval calculations.
- `glmTeachingIntervalQuantile()` centralises normal versus quasi-model t quantile selection.

The tests now document return shapes, interval semantics, response-scale transformation, unsupported-type compatibility, multi-row output shape, and quasi-model interval multiplier behaviour.

## Completed Stage 13 outcomes

### Stage 13.1

Added this tracked audit note and identified a narrow prediction-wrapper maintenance stream.

### Stage 13.2

Consolidated `newdata` data-frame validation into `validatePredictionNewdata()` and routed `predict20x()`, `predictCount()`, and `predictGLM()` through the shared helper. This removed duplicated validation while preserving output and error text.

### Stage 13.3

Consolidated internal prediction-output formatting for teaching prediction frames and GLM interval matrices. This preserved legacy column names, rounding, return classes, and scale handling for the wrappers touched at that point.

### Stage 13.4

Standardised `predictGLM()` to return a data frame rather than a matrix, with an explicit compatibility decision and regression coverage. The change preserved `fit`, `lwr`, and `upr` column names, link-scale and response-scale calculations, and fallback of unsupported `type` values to link-scale output.

### Stage 13.5

Added regression coverage for multi-row prediction outputs, binomial-logit `predictGLM()` return shapes, and wrapper-level quasi interval multiplier behaviour. This stage was coverage-focused and did not introduce further prediction-internal refactoring.

### Stage 13.6

Closed the prediction-wrapper internal-maintenance stream with this wrap-up note. No package code, tests, documentation generated from roxygen, or package version metadata needed to change for this notes-only close-out.

## Compatibility points now locked down

The following behaviours are covered by the Stage 13 audit or tests and should not be changed incidentally:

- `predict20x()` invisibly returns a list with `frame`, `fit`, `se.fit`, `residual.scale`, `df`, and `cilevel`.
- `predictCount()` invisibly returns the rounded response-scale data frame.
- `predictGLM()` returns a data frame with `fit`, `lwr`, and `upr` columns.
- Unsupported `predictGLM(type = ...)` values keep the legacy fallback to link-scale output.
- `predictGLM()` applies the inverse link to `fit`, `lwr`, and `upr` for response-scale output.
- Quasi-model interval multiplier behaviour remains explicit at the wrapper level.
- Existing compatibility-sensitive column names, including leading spaces, should not be renamed casually.
- Existing teaching-wrapper messages and printed output should not be changed incidentally.
- The prediction wrappers keep their first-order `newdata` data-frame validation semantics.

## Deferred items

The following items remain deferred because they carry higher behaviour or API risk, or because they are better handled in a separate stream:

- Replacing the teaching wrappers with ordinary `predict()` interfaces.
- Further changing return classes, visibility, column names, or rounding rules.
- Removing legacy `newdata` order and naming assumptions.
- Broadly changing `predictGLM()` link support.
- Changing printed messages or teaching output without an explicit user-visible decision.
- Refactoring diagnostic or plotting internals before starting a separate diagnostic/plotting audit stage.

## Recommended next stream

Stage 13 can now be treated as complete. The next modernisation stream should start with a fresh audit stage, for example Stage 14, focused on diagnostic and plotting internals. That stage should begin audit-only before any implementation work, following the same pattern used successfully for prediction wrappers.
