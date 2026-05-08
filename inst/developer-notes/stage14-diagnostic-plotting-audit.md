# Stage 14 diagnostic and plotting internal audit

## Scope

Stage 14.1 reviewed diagnostic and plotting internals after the Stage 13 prediction-wrapper stream. This stage is audit-only. It records focused maintenance targets for later Stage 14 sub-stages and does not redesign public APIs, rename exported functions, remove compatibility aliases, alter teaching output, update documentation, change tests, or bump the package version.

Reviewed areas:

- `modelcheck()` and `modcheck()` diagnostic wrappers (now identified for deprecation/export removal)
- `eovcheck()`, `normcheck()`, and `cooks20x()` helper plots
- legacy residual, autocorrelation, layout, boxplot, stripchart, and Q-Q plotting helpers
- current diagnostic test coverage in `tests/testthat/test-diagnostic-plot-api.R`
- graphical-parameter and layout save/restore behaviour
- residual and fitted-value extraction patterns
- return conventions for plotting side-effect helpers

## Current structure

The diagnostic plotting layer is still mostly a collection of legacy teaching helpers rather than a shared internal plotting framework.

The main current workflows are:

- `modelcheck.lm()` uses base `plot.lm()` panels and a compact custom `layout()` matrix.
- `modcheck.lm()` delegates to `eovcheck()`, `normcheck()`, and `cooks20x()` after setting a four-panel graphical layout through `par()`.
- `eovcheck.formula()` computes or reconstructs an `lm` fit, draws residuals against fitted values, and optionally adds lowess, two-standard-deviation guide lines, and Levene-test text.
- `eovcheck.lm()` reconstructs a formula/data path from the fitted model call and then delegates to `eovcheck.formula()`.
- `normcheck.default()` contains nested Q-Q and histogram plotting helpers and optionally sets `par()` depending on `usePar`.
- `normcheck.lm()` and `normcheck.tslm()` convert model objects to residual vectors and delegate to the default method.
- `cooks20x()` directly plots Cook's distances and labels the three largest values.
- legacy helpers such as `residPlot()`, `autocorPlot()`, `boxqq()`, `stripqq()`, and `layout20x()` mostly draw plots directly and return the ordinary implicit value from the final graphics call.

Current tests cover a small set of diagnostic argument-validation behaviours, but do not yet document graphical side effects, invisible returns, or layout restoration.

## Keep unchanged

These behaviours should remain stable unless a later sub-stage makes a small, deliberate, tested change:

- Exported function names that remain current after Stage 14.2 deprecates and unexports legacy helpers.
- Current teaching plot ordering and panel content for non-deprecated diagnostic helpers.
- Current argument validation messages for `which`, `plotOrder`, and `whichPlot`.
- The `usePar = FALSE` path in `normcheck()`, which is used by `modcheck()` to preserve externally managed panel layout.
- Existing public arguments such as `args`, `parVals`, `axisOpts`, `smoother`, `twosd`, `levene`, and `residualType`.
- Current model-class support unless a later stage explicitly broadens it with tests.
- Current roxygen-generated `NAMESPACE` workflow; do not manually edit `NAMESPACE`.

## Consolidate duplicated helper logic

Possible narrow improvements for later stages:

- Add a small internal helper for graphical-parameter save/restore where functions currently repeat `oldPar = par(...)` and `on.exit(par(oldPar))` patterns.
- Add a small internal helper for resetting `layout(1)` safely in `modelcheck.lm()`, because `layout()` is not restored by the existing `par()` restoration.
- Consider a common residual/fitted extraction helper for diagnostic code paths that currently use `resid()`, `residuals()`, `fitted()`, `$residuals`, and call reconstruction in different ways.
- Do not consolidate grouped Q-Q data for `boxqq.formula()` and `stripqq.formula()` unless these deprecated internals become necessary for compatibility fixes.
- Consider a narrow helper for plotting the normal curve over residual histograms only if it preserves existing defaults, labels, and axes.

Any consolidation should be internal-only and should be covered by regression tests that compare current side effects or returned values before and after the change.

## Clarify internal naming

Possible internal-only naming improvements when the surrounding code is touched:

- Normalise mixed local names such as `M`, `Plots`, `p`, `opar`, `data.f`, `terms.form`, `num.obs.per.group.min`, `usr.coords`, and `showR` only within touched functions.
- Prefer names that distinguish residual vectors, fitted values, grouped values, plot indexes, and graphical-parameter state.
- Avoid introducing new exported helpers for internal plotting mechanics.
- Correct obvious local typos only when covered by tests and when the change cannot alter teaching output.

## Add targeted regression tests

Potential tests for later sub-stages:

- `modelcheck()` should restore `par("mar")` and `par("mgp")` and should leave the layout in a predictable single-panel state after plotting.
- `modcheck()` should restore the graphical parameters it changes through `parVals`.
- `normcheck(..., usePar = TRUE)` should restore graphical parameters, while `usePar = FALSE` should not override externally managed layout.
- Because `boxqq()` and `stripqq()` are deprecated in Stage 14.2, do not invest further in their graphical-state behaviour unless a compatibility failure is reported.
- Diagnostic plotting helpers should consistently return invisibly, or current visible/implicit return behaviour should be documented as compatibility-sensitive before any change.
- `eovcheck.lm()` should be tested with model fits whose data were supplied through a standard data-frame call, because it reconstructs `formula` and `data` from the model call.
- `cooks20x()` should be tested for small model sizes before any change to the labelled-observation logic, because it currently assumes the three largest Cook's distances can be labelled.

Tests should use deterministic built-in data, offline execution, and graphics devices that avoid interactive display.

## Defer because behaviour/API risk is too high

The following are not suitable as incidental Stage 14 changes:

- Replacing diagnostic helpers with ggplot2 or changing the visual style of teaching plots.
- Renaming exported diagnostic functions or public arguments.
- Removing legacy helpers or aliases used by older teaching material.
- Broadly changing the return values of plotting side-effect functions without explicit compatibility tests.
- Changing `eovcheck.lm()` model-call reconstruction semantics without testing representative legacy usages.
- Changing model-class support for `lm` or `tslm` diagnostics as part of an unrelated cleanup.
- Normalising all plotting code style in one broad pass, because that risks visual and behavioural drift.

## Recommended next sub-stage

Stage 14.2 should first remove obsolete diagnostic helpers from the exported API and mark them as deprecated: `modelcheck()`, `modcheck()`, `boxqq()`, `stripqq()`, and the legacy `autocor.plot()` alias. After that, later Stage 14 work should focus only on currently exported diagnostic helpers, especially `normcheck()`, `eovcheck()`, `cooks20x()`, `residPlot()`, `autocorPlot()`, and related plotting side effects.
