# Stage 11.5 legacy API and teaching-wrapper audit

## Purpose

This note records a deeper Stage 11 review of outdated or ambiguous parts of the `s20x` API. The goal is not to make arguments match a coding style, but to decide which older teaching helpers still have a clear role, which should be documented more explicitly, and which are candidates for later modernisation or deprecation.

Stage 11 should remain compatibility-first. Student-facing names should not be removed abruptly, and old course material should keep working unless there is a deliberate deprecation plan.

## Review principles

Use these categories when reviewing exported functions:

- **Keep as teaching wrapper**: the function still simplifies an important teaching workflow.
- **Modernise internally**: the interface can remain, but internals should use clearer helpers, safer checks, or less duplicated code.
- **Document more clearly**: the function is still useful, but its relationship to base R or package dependencies needs clearer documentation.
- **Deprecation candidate**: the function appears superseded, unused, or confusing, but should be retained until a staged deprecation path is agreed.
- **Later refactor candidate**: the function works but has broad scope, hidden side effects, or duplicated patterns that should be split in a future refactor stage.

## High-priority candidates

### Prediction helpers

Functions:

- `predict20x()`
- `predictCount()`
- `predictGLM()`

Current assessment:

- `predict20x()` is already documented as deprecated and is closest to being a legacy compatibility wrapper.
- `predictCount()` and `predictGLM()` overlap in purpose, but they return different object shapes and have different printing behaviour.
- These functions are teaching wrappers, not S3 `predict()` methods and not drop-in replacements for base R prediction methods.

Recommended direction:

- Keep the current functions for compatibility in Stage 11.
- Do not add cosmetic aliases simply to match argument style.
- Consider a later implementation stage that extracts shared internal prediction-interval logic while preserving all exported wrappers.
- Consider whether `predictCount()` should eventually become a thin documented wrapper around a common GLM helper.

### Deprecated plotting and summary helpers

Functions:

- `boxqq()`
- `stripqq()`
- `crosstabs()`
- `freq1way()`
- `layout20x()`
- `residPlot()`
- `autocor.plot()` alias for `autocorPlot()`

Current assessment:

- Several functions are documented as deprecated or scheduled for future removal.
- Some may still exist in old teaching notes or student material.
- Their deprecation wording is inconsistent, and some notes say they will be removed without giving a replacement or transition path.

Recommended direction:

- Do not remove any of these in Stage 11.
- Standardise deprecation wording in a later documentation-only stage.
- Where possible, name the preferred replacement in the help file.
- Consider adding lightweight lifecycle tests that confirm deprecated wrappers still dispatch to the intended behaviour.

### Diagnostic plotting wrappers

Functions:

- `modelcheck()`
- `modcheck()`
- `normcheck()`
- `eovcheck()`
- `cooks20x()`
- `residPlot()`
- `autocorPlot()`

Current assessment:

- These functions provide the strongest ongoing teaching value because they make diagnostics more accessible.
- Several functions modify graphics state and layout. Most now restore graphics state, but the pattern is not fully consistent.
- `modelcheck()` and `modcheck()` overlap in concept and may confuse users unless their roles are clearly documented.
- `tslm()` support has been added to some diagnostic flows, but not all related wrappers have been reviewed together.

Recommended direction:

- Keep these as teaching wrappers.
- Review graphics-state handling as a later non-behavioural reliability stage.
- Clarify the relationship between `modelcheck()` and `modcheck()` before changing either interface.
- Consider whether `tslm` methods should be added for additional diagnostic generics only where the teaching need is clear.

### Case-study helpers

Functions:

- `casestudy()` / `cs()`
- `openCaseStudy()` / `opencs()` / `ocs()`
- `listCaseStudies()` / `listCS()` / `lcs()`

Current assessment:

- These helpers are still useful as a teaching interface around package-shipped case studies.
- Recent stages added compatibility aliases for directory arguments.
- The helpers rely on optional packages and interactive behaviour, so tests should avoid opening editors, browsers, or rendering full documents unless explicitly isolated.

Recommended direction:

- Keep the helpers.
- Prefer documentation and tests around non-interactive resolution logic.
- Avoid expanding interactive behaviour until the non-interactive paths are fully stable.

### Contrast and multiple-comparison helpers

Functions:

- `estimateContrasts()`
- `multipleComp()`
- `displayPairs()`
- `propslsd.new()`

Current assessment:

- These functions wrap older teaching workflows around contrasts and multiple comparisons.
- `displayPairs()` and `multipleComp()` depend on `emmeans` behaviour and object column names.
- `propslsd.new()` is documented as not exported and deprecated, but it remains in the codebase.

Recommended direction:

- Keep user-facing helpers until their current teaching use is known.
- Add tests around object-shape expectations before refactoring internals.
- Consider whether non-exported deprecated helpers should be moved behind clearer internal names in a later refactor stage.

### `tslm()` interface

Current assessment:

- `tslm()` is the newest teaching interface and has the clearest modern design direction.
- It intentionally wraps `lm()` and `nlme::gls()` while exposing familiar model generics.
- Stage 11 should avoid destabilising `tslm()` while older API areas are still being audited.

Recommended direction:

- Treat `tslm()` as the reference model for future teaching-wrapper design.
- Use clear S3 methods where the wrapper represents a model object.
- Preserve explicit compatibility and diagnostic behaviour added in earlier stages.

## Suggested Stage 11 sequence from here

1. Documentation-only deprecation cleanup for legacy helpers.
2. Non-behavioural tests for current diagnostic and prediction wrapper outputs.
3. Internal helper extraction for duplicated prediction logic, only after tests are in place.
4. Graphics-state reliability cleanup for diagnostic plotting wrappers.
5. A later deprecation-policy stage if any functions should be formally retired.

## Stage 11.5 decision

Stage 11.5 makes no public API changes. It records this audit so that later Stage 11 changes are driven by teaching value, compatibility, and maintainability rather than by surface-level argument naming.

## Stage 11.6 decision

Stage 11.6 extracts the duplicated base prediction calls used by `predict20x()`, `predictCount()`, and `predictGLM()` into small internal helpers. The public wrappers keep their existing names, arguments, return shapes, printed output, and scale-specific behaviour. This is intended as a maintenance step only: later stages can now review interval handling or return conventions with a smaller duplicated-code surface.


## Stage 11.7 decision

Stage 11.7 consolidates duplicated confidence-interval and prediction-interval arithmetic used by `predict20x()`, `predictCount()`, and `predictGLM()` into internal helpers. The public wrappers keep their existing names, arguments, return shapes, printed output, and scale-specific behaviour. This keeps the prediction-family modernisation focused on maintainability before any later discussion of interface changes.

## Stage 11.8 decision

Stage 11.8 adds regression tests that describe the current interval semantics of the prediction teaching wrappers. These tests intentionally document the existing behaviour before any later API or return-object changes are considered:

- `predict20x()` reports confidence and prediction intervals using a t multiplier on the linear-model scale.
- `predictCount()` reports rounded response-scale counts by exponentiating link-scale fitted values and confidence limits.
- `predictGLM()` reports link-scale estimates by default and applies the fitted model inverse link to the full fit/lower/upper matrix when `type = "response"`.

No public API or calculation changes are made in this stage.

## Stage 11.9 decision

Stage 11.9 standardises deprecation and legacy-helper documentation wording for older teaching wrappers. The change avoids promising abrupt removal where no replacement or deprecation schedule has been agreed. Instead, the documentation now distinguishes between legacy aliases, retained teaching helpers, and internal helpers.

No functions are removed and no public behaviour is changed in this stage.

