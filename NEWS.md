# s20x 3.2.285

## Modernisation
- Added an optional ggplot2 engine to eovcheck() while preserving the original base graphics output as the default.
- Returned a ggplot object for the optional residual-versus-fitted equality-of-variance diagnostic when ggplot2 is installed.

# s20x 3.2.280

## Modernisation
- Added an optional ggplot2 engine to normcheck() while preserving the original base graphics output as the default.
- Returned ggplot objects for optional normal Q-Q and residual histogram diagnostics when ggplot2 is installed.

# s20x 3.2.278

## Modernisation
- Added an optional ggplot2/GGally engine to pairs20x() while preserving the original base graphics output as the default.

# s20x 3.2.276

## Data
- Store `nzarrivals.df$month` as a factor with levels ordered by `month.abb` and update the dataset documentation accordingly.

# s20x 3.2.274

## Data
- Add `nzarrivals.df`, a monthly Stats NZ Infoshare arrivals data set, and fix the Stage 14 `colors()` import so note-level checks remain strict.

# s20x 3.2.273

- Document remaining Stage 14 internal helper functions with roxygen2 comments.

# s20x 3.2.272

- Document internal prediction helper functions with roxygen2 comments.

# s20x 3.2.271

## Modernisation
- Removed qualified namespace calls from R source files by adding roxygen imports, broadened internal helper documentation, and hardened the Stage 14 style-compliance regression test.

# s20x 3.2.270

## Modernisation
- Consolidated residual and fitted-value extraction for targeted diagnostic plotting internals without changing plotting output or public APIs.

# s20x 3.2.269

## Modernisation
- Added a small internal graphics-parameter save/restore helper and used it in targeted diagnostic plotting code paths without changing plotting output.

# s20x 3.2.268

## Modernisation
- Deprecated legacy diagnostic plotting helpers `modelcheck()`, `modcheck()`, `boxqq()`, `stripqq()`, and the `autocor.plot()` alias, and removed them from the exported API while keeping their internal compatibility definitions.

# s20x 3.2.267

## Modernisation
- Added prediction-wrapper regression coverage for multi-row return shapes, binomial-logit `predictGLM()` output, and wrapper-level quasi interval multiplier behaviour without changing prediction internals.

# s20x 3.2.264

## Modernisation
- Standardised `predictGLM()` return shape to a data frame with stable `fit`, `lwr`, and `upr` columns, while preserving link/response scale calculations and legacy fallback to link-scale output for unsupported `type` values.

# s20x 3.2.263

## Modernisation
- Consolidated internal prediction interval output formatting for linear-model and GLM teaching wrappers while preserving legacy return shapes, column names, rounding, and scale handling.

# s20x 3.2.262

## Modernisation
- Consolidated prediction-wrapper `newdata` data-frame validation into a shared internal helper and removed duplicated validation from `predictGLM()` without changing prediction output or error text.

# s20x 3.2.261

## Modernisation
- Added the Stage 13 prediction-wrapper internal audit note, identifying narrow maintenance targets for prediction internals while deferring public API and behaviour changes.

# s20x 3.2.260

## Modernisation
- Finalised the Stage 12 documentation-coherence developer note, summarising completed documentation improvements and deferring deeper API or behavioural refactors to later stages.

# s20x 3.2.259

## Modernisation
- Audited exported help examples for strict-check suitability, confirmed remaining synthetic examples are deterministic or guarded, and tightened `freq1way()` documentation wording without changing behaviour.

# s20x 3.2.258

## Modernisation
- Standardised diagnostic help wording for model checking, residuals versus fitted values, Q-Q plots, and plotting side effects without changing package behaviour.

# s20x 3.2.257

## Modernisation
- Guarded the `displayPairs()` help example so it only runs the optional `emmeans` workflow when `emmeans` is available, keeping examples suitable for strict checks without changing package behaviour.

# s20x 3.2.256

## Modernisation
- Clarified prediction helper and AR-error model documentation so teaching wrappers are distinguished from ordinary `predict()` and independent-error ANOVA behaviour without changing package behaviour.

# s20x 3.2.255

## Modernisation
- Replaced the artificial `summary1way()` help example with `computer.df`, made the `summaryStats()` matrix example dataset-based, and tightened summary-helper documentation wording without changing behaviour.

# s20x 3.2.254

## Modernisation
- Applied a strict NZ English and grammar documentation pass and accepted `"normalised"` as a package-owned alias for `"normalized"` residual diagnostics while preserving compatibility.

# s20x 3.2.253

## Modernisation
- Made diagnostic helper examples deterministic or dataset-based and corrected small documentation spelling and grammar issues without changing diagnostic behaviour.

# s20x 3.2.252

## Modernisation
- Replaced the `interactionPlots()` help examples with the `arousal.df` teaching dataset and clarified the deprecated vector-form example wording without changing plotting behaviour.

# s20x 3.2.251

## Modernisation
- Added a Stage 12 documentation audit covering help examples, teaching datasets, time-series examples, `R CMD check` suitability, and NZ English spelling and grammar notes without changing package behaviour.

# s20x 3.2.250

## Modernisation
- Added a Stage 11 completion plan summarising completed API-consistency work and deferring larger documentation and internal refactor items to later stages.

# s20x 3.2.249

## Modernisation
- Documented diagnostic plotting helper return conventions and added regression tests for current validation behaviour without changing plotting behaviour.

# s20x 3.2.248

## Modernisation
- Documented and tested `crosstabs()` and `rowdistr()` printed-output and invisible-return conventions without changing behaviour.

# s20x 3.2.247

## Modernisation
- Documented and tested `summary2way()` printed-output and invisible-return conventions without changing behaviour.

# s20x 3.2.246

## Modernisation
- Documented and tested `summary1way()` printed-output and invisible-return conventions without changing behaviour.

# s20x 3.2.245

## Modernisation
- Documented and tested `summaryStats()` printed-output and invisible-return conventions without changing behaviour.

# s20x 3.2.244

## Modernisation
- Added a Stage 11 return-convention modernisation plan to guide future low-risk API updates without changing public behaviour.

# s20x 3.2.243

## Modernisation
- Added a Stage 11 audit of printed-output and invisible-return conventions without changing public behaviour.

# s20x 3.2.242

## Modernisation
- Standardised legacy-helper documentation wording without changing public behaviour.

# s20x 3.2.241

## Modernisation
- Added regression tests documenting current prediction interval semantics before further API changes.

# s20x 3.2.240

## Modernisation
- Consolidated shared confidence-interval arithmetic for prediction teaching wrappers without changing public prediction behaviour.

## Modernisation
- Extracted shared internal prediction helpers for linear-model and GLM teaching wrappers without changing public prediction behaviour.

## Modernisation
- Added a deeper Stage 11 legacy API audit focused on outdated teaching wrappers, deprecation candidates, and future modernisation priorities.


## Modernisation
- Added a camelCase `outputDir` alias for rendered case-study helpers while preserving `output_dir` compatibility.
- Clarified prediction helper documentation so their teaching-wrapper roles and return values are explicit.
- Added a Stage 11 API consistency audit for prediction helpers before changing public interfaces.
- Completed the Stage 10 style-normalisation sweep for remaining legacy helpers without changing public interfaces.
- Normalised style in Cook's distance plotting helpers without changing their public interface.
- Normalised style in count prediction helpers without changing their public interface.
- Normalised style in row distribution helpers without changing their public interface.
- Normalised style in residual diagnostic plotting helpers without changing their public interface.
- Normalised style in autocorrelation plotting helpers without changing their public interface.
- Normalised style in trend scatter plotting helpers without changing their public interface.
- Normalised style in two-way ANOVA summary helpers without changing their public interface.
- Normalised style in summary statistics helpers without changing their public interface.
- Normalised style in the deprecated one-way frequency table helper without changing its public interface.
- Normalised style in the one-way ANOVA summary helper without changing its public interface.
- Normalised style in package version and skewness utility helpers without changing their public interface.
- Normalised style in regression confidence interval helpers without changing their public interface.
- Normalised style in generalised linear model prediction helpers without changing their public interface.
- Normalised style in one-way comparison helper functions without changing their public interface.
- Normalised style in case study helper functions without changing their public interface.
- Normalised style in deprecated grouped QQ plotting helpers.
- Normalised style in small utility files as part of the staged modernisation work.
- Added package infrastructure for automated R CMD check runs.
- Updated package build ignores for repository-only infrastructure files.
