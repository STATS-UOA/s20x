# Stage 11 API consistency audit

## Purpose

Stage 11 should make user-facing interfaces more consistent without changing teaching behaviour abruptly. The prediction helpers are a good first audit target because they look similar to base `predict()` at first glance, but they are not simple replacements for base prediction methods.

## Prediction helper audit

### `predict20x()`

Current role:

- Teaching helper for `lm` objects.
- Requires `newdata` to be a data frame.
- Reconstructs expected column names from the model terms and assigns them to `newdata`.
- Calls `predict.lm(..., se.fit = TRUE)`.
- Returns an invisible list containing a printed data frame plus fit metadata.
- Produces both confidence intervals and prediction intervals.
- Uses `cilevel` rather than base R's `level` naming.
- Is documented as deprecated in favour of standard `predict()`.

API notes:

- This is not an S3 `predict()` method.
- It is a teaching wrapper around `predict.lm()` with additional printed output.
- Adding base-style aliases such as `conf.level` should not be the first change because the function is already deprecated and its return shape is intentionally different from base R.

### `predictCount()`

Current role:

- Teaching helper for count-style `glm` models, typically log-link Poisson models.
- Requires `newdata` to be a data frame.
- Reconstructs expected column names from the model terms and assigns them to `newdata`.
- Calls `predict.glm(..., se.fit = TRUE)` on the link scale unless the caller passes another `type` through `...`.
- Exponentiates the fitted values and confidence limits.
- Returns an invisible data frame with predicted values and confidence limits.
- Uses `cilevel` rather than base R's `level` naming.

API notes:

- This is a specialised teaching wrapper for log-link count predictions.
- Its implicit exponentiation makes it more specialised than base `predict.glm()`.
- It overlaps with `predictGLM(type = "response")`, but its printed data-frame workflow is different.

### `predictGLM()`

Current role:

- Teaching helper for log-link and logit-link `glm` models.
- Requires `newdata` to provide all first-order terms.
- Calls `predict.glm(..., se.fit = TRUE)`.
- Returns a matrix with fit, lower, and upper columns.
- Supports `type = "link"` and `type = "response"` by applying the model inverse link to the fitted values and intervals.
- Uses `cilevel` rather than base R's `level` naming.
- Prints a message identifying whether the estimates are on the link or response scale.

API notes:

- This is the most general of the three prediction helpers.
- It may be a better future home for shared GLM prediction logic than `predictCount()`.
- Its return value and printed message differ from both base `predict.glm()` and `predictCount()`.

## Recommendation

Do not immediately add new public aliases or reshape return objects. Instead:

1. Preserve the current exported function names for compatibility.
2. Keep `predict20x()` deprecated unless there is a clear teaching need to revive it.
3. Treat `predictCount()` as a legacy count-focused wrapper and consider documenting its relationship to `predictGLM(type = "response")` before changing its interface.
4. Consider extracting a small internal helper for GLM interval construction in a later stage, but only after tests lock down the current link-scale and response-scale behaviour.
5. If a base-style argument name is added later, prefer a carefully documented compatibility layer rather than silently changing the primary argument names.

## Stage 11 follow-up candidates

- Add behaviour-preserving tests for `predict20x()`, `predictCount()`, and `predictGLM()` before any implementation refactor.
- Review whether `predictCount()` should eventually delegate to a shared internal helper used by `predictGLM()`.
- Review documentation wording so users understand these are teaching helpers, not drop-in replacements for base `predict()` methods.
- Avoid introducing S3 methods unless there is a clear benefit, because these helpers currently have explicit teaching-oriented names.
