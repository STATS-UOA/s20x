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

## Stage 11.2 documentation decision

Stage 11.2 keeps the prediction helper interfaces unchanged and clarifies the documentation instead. The three exported helpers remain explicit teaching wrappers rather than S3 `predict()` methods:

- `predict20x()` remains a deprecated `lm` teaching helper that prints both confidence and prediction intervals.
- `predictCount()` remains a count-focused `glm` teaching helper that returns rounded response-scale counts from a log-link model.
- `predictGLM()` remains the more general log-link/logit-link helper that returns a fit/lower/upper matrix on either the link or response scale.

This avoids implying that the helpers are drop-in replacements for base `predict()` methods. Later implementation stages can still extract shared internal interval helpers, but they should do so behind the existing exported interfaces and after current behaviour remains locked down by tests.

## Stage 11.3 case-study destination argument decision

Stage 11.3 adds a camelCase `destDir` compatibility alias for the case-study opener family while retaining the legacy `dest_dir` argument. This keeps existing teaching material working and gives new code a package-style-consistent argument name.

The alias is accepted through `...` so existing positional calls to `openCaseStudy(id, dest_dir, overwrite)`, `opencs()`, and `ocs()` keep their current meaning. Ambiguous calls that supply both `dest_dir` and `destDir` with different destinations are rejected explicitly. Unsupported extra arguments are also rejected so misspelled argument names do not get silently ignored.

## Stage 11.4 rendered case-study output argument decision

Stage 11.4 adds a camelCase `outputDir` compatibility alias for `casestudy()` and `cs()` while retaining the legacy `output_dir` argument. This mirrors the Stage 11.3 destination-directory decision for `openCaseStudy()` and keeps the case-study helper family moving toward consistent camelCase names without breaking existing teaching material.

The alias is accepted through `...` so existing positional calls to `casestudy(id, output_dir, open, quiet)` keep their current meaning. Any remaining `...` arguments are still passed to `rmarkdown::render()`. Ambiguous calls that supply both `output_dir` and `outputDir` are rejected explicitly.

## Stage 11.5 exported-argument inventory decision

Stage 11.5 makes no public API changes. It records an exported-argument inventory so later API consistency work can be chosen deliberately rather than adding aliases opportunistically.

The current exported interfaces fall into four broad groups:

1. Base-style modelling interfaces that should remain close to their generic equivalents, including `tslm()` methods and functions that already use names such as `formula`, `data`, `object`, `newdata`, `conf.level`, and `...`.
2. Teaching wrappers with long-standing legacy names that should be preserved unless a compatibility layer is added, including `predict20x()`, `predictCount()`, `predictGLM()`, `modcheck()`, `modelcheck()`, `normcheck()`, and `eovcheck()`.
3. Case-study helpers where camelCase aliases have already been added for path-like arguments while retaining the historical snake_case names.
4. Older teaching helpers with non-standard but familiar arguments, such as `print.out`, `show.table`, `data.order`, `interval.type`, `plotOrder`, and `asDF`.

Recommended next steps:

- Do not rename arguments in place.
- Add aliases only when the public benefit is clear and existing positional calls are protected.
- Prefer documentation clarification for deprecated or legacy helpers before adding new compatibility names.
- Treat return-value consistency as a separate sub-stage from argument-name consistency.
- Consider small resolver helpers only when multiple exported functions share the same compatibility pattern.

Candidate follow-up stages:

- Review printed-output switches such as `print.out`, `show.table`, and `verbose` for documentation consistency before changing interfaces.
- Review return-value conventions for prediction helpers and summary helpers separately.
- Review plot-check helper argument names such as `plotOrder`, `twosd`, and `smoother` only if there is a teaching benefit to aliases.

## Stage 11.10 printed-output and invisible-return audit decision

Stage 11.10 makes no public API changes. It records the current printed-output and invisible-return conventions as a separate API consistency concern from argument naming. This keeps Stage 11 focused on teaching behaviour rather than cosmetic interface changes.

The next implementation stages should treat printed output as part of the public teaching interface. Helpers that print tables, messages, or plots while returning objects invisibly should not be changed until tests or notes describe the existing behaviour.

Recommended follow-up actions:

- Preserve printed labels and column names unless there is a clear teaching reason to update them.
- Add tests around invisible return values before changing helpers that primarily print output.
- Prefer documentation clarification over return-shape changes for legacy helpers.
- Review one helper family at a time, especially summary helpers and model-check plotting helpers.
