# s20x development news

## Purpose











## s20x 3.2.310

- Polished the optional ggplot2 eovcheck output so the two-standard-deviation reference lines remain visible.
- Included the plus/minus two-standard-deviation limits in the plotted y-range and matched the base plot line weight more closely.
- Removed the default grey ggplot2 panel styling from the optional eovcheck engine to keep the teaching plot closer to base graphics.
- Kept the base graphics engine as the default and preserved the optional ggplot2 object-return path.
- Validated by the standard s20x stage workflow.

## s20x 3.2.309

- Extended the optional normcheck() ggplot2 histogram density curve across the full displayed x-axis range.
- Kept the histogram as a native ggplot2 geom_histogram() layer while replacing stat_function() with explicit density data.
- Preserved base graphics defaults and existing normcheck() return behaviour.
- Documented the Stage 19.5 normcheck density-curve polish notes.
- Validated by the standard s20x stage workflow.

## s20x 3.2.308

- Polished the optional ggplot2/GGally engine for pairs20x() while preserving base graphics as the default.
- Renamed internal pairs20x ggplot2 helpers to use clearer *_ggplot2 names.
- Kept the existing ggplot2/GGally example and return-class tests for the optional plot matrix path.
- Documented the Stage 19.4 pairs20x plotting-engine review notes.
- Validated by the standard s20x stage workflow.

## s20x 3.2.307

- Polished the optional ggplot2 engine for modelcheck() while preserving base graphics as the default.
- Renamed internal modelcheck ggplot2 helpers and list classes to use clearer *_ggplot2 names.
- Reworked ggplot2 aesthetic mappings to use data-column pronouns and avoid external-vector warnings.
- Added a print method for multiple ggplot2 modelcheck plots and ggplot2-engine examples for individual diagnostics.
- Added offline regression tests for the renamed class and clean plot printing.
- Validated by the standard s20x stage workflow.

## s20x 3.2.306

- Polished the optional ggplot2 engine for eovcheck() while preserving base graphics as the default.
- Renamed internal eovcheck ggplot2 helpers to use clearer *_ggplot2 names.
- Reworked ggplot2 aesthetic mappings to use data-column pronouns and avoid external-vector warnings.
- Added ggplot2-engine examples and an offline regression test for clean plot printing.
- Validated by the standard s20x stage workflow.

## s20x 3.2.305

- Restored the documented s20xNormcheckGgplot2 return class while retaining the clearer internal s20xNormcheck_ggplot2 class alias.
- Preserved the Stage 19.1 ggplot2 normcheck plotting fixes, examples, and naming cleanup.
- Fixed compatibility with existing diagnostic plotting tests after the internal class-name cleanup.
- Preserved base graphics as the default plotting engine and kept ggplot2 optional.
- Validated by the standard s20x stage workflow.

## s20x 3.2.303

- Added regression tests that scan controlled R and test files for namespace operators in executable code.
- Added regression tests that scan controlled R and test files for dynamic namespace lookup helpers.
- Reworked the internal-test helper to avoid getFromNamespace() while preserving access to unexported helpers during tests.
- Preserved the Stage 18.6 import-based plotting cleanup and base graphics defaults.
- Validated by the standard s20x stage workflow.

## s20x 3.2.302

- Replaced dynamic ggplot2 and GGally plotting function lookups with direct calls backed by roxygen import declarations.
- Moved ggplot2 and GGally into Imports so their functions can be declared through NAMESPACE.
- Removed namespace operator usage from controlled package and test code by using imported functions and a shared internal-test helper.
- Preserved base graphics as the default plotting engine.
- Validated by the standard s20x stage workflow.

## s20x 3.2.301

- Refactored normcheck ggplot2 Q-Q and histogram builders to use grouped optional plotting function lookups.
- Refactored the eovcheck ggplot2 diagnostic builder to use grouped optional plotting function lookups.
- Preserved base graphics as the default engine and kept ggplot2 optional.
- Validated by the standard s20x stage workflow.

## s20x 3.2.300

- Added a grouped optional plotting function lookup helper for ggplot2 implementations.
- Refactored modelcheck ggplot2 residual and Cook distance builders to use grouped helper lookups.
- Preserved base graphics as the default engine and kept ggplot2 optional.
- Validated by the standard s20x stage workflow.

## s20x 3.2.299

- Centralised optional plotting function lookup behind the internal getPlottingFunction() helper.
- Replaced repeated direct getExportedValue() calls in the ggplot2 and GGally plotting implementations.
- Preserved base graphics as the default engine and kept ggplot2/GGally optional.
- Validated by the standard s20x stage workflow.

## s20x 3.2.298

- Added matchPlottingEngine() as a shared internal helper for plotting engine argument matching.
- Replaced repeated match.arg(engine) calls in normcheck(), eovcheck(), modelcheck(), and pairs20x().
- Added a Stage 18.2 plotting engine dispatch note for the cleanup and deferred candidates.
- Ignored the local .s20x_validation_mode file so R CMD check tarballs do not include validation state.
- Preserved base graphics defaults, optional ggplot2/GGally behavior, and teaching-oriented plotting output.

This file records user-facing and developer-facing changes for s20x. It is a release-note summary, not a commit-by-commit history.

## s20x 3.2.297

- Added a shared internal helper for optional plotting package availability checks.
- Replaced duplicated ggplot2 and GGally engine checks in normcheck(), eovcheck(), modelcheck(), and pairs20x().
- Added a Stage 18.1 plotting audit note to record remaining cleanup candidates.
- Preserved base graphics defaults, optional ggplot2/GGally behavior, and teaching-oriented plotting output.


# s20x 3.2.295

### Modernisation
- Completed a final consistency pass over README and package-level plotting-engine documentation.
- Clarified optional ggplot2 and GGally requirements for diagnostic plotting helpers.
- Ignored stage-runner validation scratch files in package builds so strict checks do not report them as hidden-file notes.
- No plotting behaviour or public API changed.

# s20x 3.2.294

### Modernisation
- Clarified README guidance for choosing between base and ggplot2 diagnostic plotting engines.
- Added package-level documentation describing stable teaching defaults and optional plotting engines.
- No plotting behaviour or public API changed.

# s20x 3.2.293

### Modernisation
- Added a README-level explanation of the optional diagnostic plotting engines while preserving base graphics as the default teaching workflow.
- Added a Stage 17.4 developer note recording the documentation-only scope and optional-dependency guard pattern.
- No plotting behaviour or public API changed.

# s20x 3.2.288

### Development notes
- Archived the Stage 16 plotting modernisation developer note under Completed.
- Recorded that pairs20x(), normcheck(), eovcheck(), and modelcheck() now have optional ggplot2 engines with base graphics preserved as the default.
- Kept this as a documentation wrap-up stage with no intended plotting behavior changes.

# s20x 3.2.287

### Modernisation
- Refined the optional ggplot2/GGally panels in pairs20x() with a base-like white theme.
- Preserved the original base graphics output as the default teaching path.
- Kept GGally and ggplot2 as optional dependencies for the modern plotting engine.

# s20x 3.2.286

### Modernisation
- Added an optional ggplot2 engine to modelcheck() while preserving the original base graphics output as the default.
- Returned a ggplot object for the optional residual-versus-fitted model checking diagnostic when ggplot2 is installed.

# s20x 3.2.285

### Modernisation
- Added an optional ggplot2 engine to eovcheck() while preserving the original base graphics output as the default.
- Returned a ggplot object for the optional residual-versus-fitted equality-of-variance diagnostic when ggplot2 is installed.

# s20x 3.2.280

### Modernisation
- Added an optional ggplot2 engine to normcheck() while preserving the original base graphics output as the default.
- Returned ggplot objects for optional normal Q-Q and residual histogram diagnostics when ggplot2 is installed.

# s20x 3.2.278

### Modernisation
- Added an optional ggplot2/GGally engine to pairs20x() while preserving the original base graphics output as the default.

# s20x 3.2.276

### Data
- Store `nzarrivals.df$month` as a factor with levels ordered by `month.abb` and update the dataset documentation accordingly.

# s20x 3.2.274

### Data
- Add `nzarrivals.df`, a monthly Stats NZ Infoshare arrivals data set, and fix the Stage 14 `colors()` import so note-level checks remain strict.

# s20x 3.2.273

- Document remaining Stage 14 internal helper functions with roxygen2 comments.

# s20x 3.2.272

- Document internal prediction helper functions with roxygen2 comments.

# s20x 3.2.271

### Modernisation
- Removed qualified namespace calls from R source files by adding roxygen imports, broadened internal helper documentation, and hardened the Stage 14 style-compliance regression test.

# s20x 3.2.270

### Modernisation
- Consolidated residual and fitted-value extraction for targeted diagnostic plotting internals without changing plotting output or public APIs.

# s20x 3.2.269

### Modernisation
- Added a small internal graphics-parameter save/restore helper and used it in targeted diagnostic plotting code paths without changing plotting output.

# s20x 3.2.268

### Modernisation
- Deprecated legacy diagnostic plotting helpers `modelcheck()`, `modcheck()`, `boxqq()`, `stripqq()`, and the `autocor.plot()` alias, and removed them from the exported API while keeping their internal compatibility definitions.

# s20x 3.2.267

### Modernisation
- Added prediction-wrapper regression coverage for multi-row return shapes, binomial-logit `predictGLM()` output, and wrapper-level quasi interval multiplier behaviour without changing prediction internals.

# s20x 3.2.264

### Modernisation
- Standardised `predictGLM()` return shape to a data frame with stable `fit`, `lwr`, and `upr` columns, while preserving link/response scale calculations and legacy fallback to link-scale output for unsupported `type` values.

# s20x 3.2.263

### Modernisation
- Consolidated internal prediction interval output formatting for linear-model and GLM teaching wrappers while preserving legacy return shapes, column names, rounding, and scale handling.

# s20x 3.2.262

### Modernisation
- Consolidated prediction-wrapper `newdata` data-frame validation into a shared internal helper and removed duplicated validation from `predictGLM()` without changing prediction output or error text.

# s20x 3.2.261

### Modernisation
- Added the Stage 13 prediction-wrapper internal audit note, identifying narrow maintenance targets for prediction internals while deferring public API and behaviour changes.

# s20x 3.2.260

### Modernisation
- Finalised the Stage 12 documentation-coherence developer note, summarising completed documentation improvements and deferring deeper API or behavioural refactors to later stages.

# s20x 3.2.259

### Modernisation
- Audited exported help examples for strict-check suitability, confirmed remaining synthetic examples are deterministic or guarded, and tightened `freq1way()` documentation wording without changing behaviour.

# s20x 3.2.258

### Modernisation
- Standardised diagnostic help wording for model checking, residuals versus fitted values, Q-Q plots, and plotting side effects without changing package behaviour.

# s20x 3.2.257

### Modernisation
- Guarded the `displayPairs()` help example so it only runs the optional `emmeans` workflow when `emmeans` is available, keeping examples suitable for strict checks without changing package behaviour.

# s20x 3.2.256

### Modernisation
- Clarified prediction helper and AR-error model documentation so teaching wrappers are distinguished from ordinary `predict()` and independent-error ANOVA behaviour without changing package behaviour.

# s20x 3.2.255

### Modernisation
- Replaced the artificial `summary1way()` help example with `computer.df`, made the `summaryStats()` matrix example dataset-based, and tightened summary-helper documentation wording without changing behaviour.

# s20x 3.2.254

### Modernisation
- Applied a strict NZ English and grammar documentation pass and accepted `"normalised"` as a package-owned alias for `"normalized"` residual diagnostics while preserving compatibility.

# s20x 3.2.253

### Modernisation
- Made diagnostic helper examples deterministic or dataset-based and corrected small documentation spelling and grammar issues without changing diagnostic behaviour.

# s20x 3.2.252

### Modernisation
- Replaced the `interactionPlots()` help examples with the `arousal.df` teaching dataset and clarified the deprecated vector-form example wording without changing plotting behaviour.

# s20x 3.2.251

### Modernisation
- Added a Stage 12 documentation audit covering help examples, teaching datasets, time-series examples, `R CMD check` suitability, and NZ English spelling and grammar notes without changing package behaviour.

# s20x 3.2.250

### Modernisation
- Added a Stage 11 completion plan summarising completed API-consistency work and deferring larger documentation and internal refactor items to later stages.

# s20x 3.2.249

### Modernisation
- Documented diagnostic plotting helper return conventions and added regression tests for current validation behaviour without changing plotting behaviour.

# s20x 3.2.248

### Modernisation
- Documented and tested `crosstabs()` and `rowdistr()` printed-output and invisible-return conventions without changing behaviour.

# s20x 3.2.247

### Modernisation
- Documented and tested `summary2way()` printed-output and invisible-return conventions without changing behaviour.

# s20x 3.2.246

### Modernisation
- Documented and tested `summary1way()` printed-output and invisible-return conventions without changing behaviour.

# s20x 3.2.245

### Modernisation
- Documented and tested `summaryStats()` printed-output and invisible-return conventions without changing behaviour.

# s20x 3.2.244

### Modernisation
- Added a Stage 11 return-convention modernisation plan to guide future low-risk API updates without changing public behaviour.

# s20x 3.2.243

### Modernisation
- Added a Stage 11 audit of printed-output and invisible-return conventions without changing public behaviour.

# s20x 3.2.242

### Modernisation
- Standardised legacy-helper documentation wording without changing public behaviour.

# s20x 3.2.241

### Modernisation
- Added regression tests documenting current prediction interval semantics before further API changes.

# s20x 3.2.240

### Modernisation
- Consolidated shared confidence-interval arithmetic for prediction teaching wrappers without changing public prediction behaviour.

### Modernisation
- Extracted shared internal prediction helpers for linear-model and GLM teaching wrappers without changing public prediction behaviour.

### Modernisation
- Added a deeper Stage 11 legacy API audit focused on outdated teaching wrappers, deprecation candidates, and future modernisation priorities.


### Modernisation
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

## s20x 3.2.296

- Clarified README guidance for ggplot2 diagnostic return values.
- Added tests that pin named-list return contracts for multi-plot ggplot2 diagnostics.
- Confirmed single selected diagnostics still return individual ggplot objects where appropriate.
- Preserved base graphics as the default plotting engine.

## s20x 3.2.292

- Removed no-op examplesIf blocks from deprecated, unexported legacy helper documentation.
- Clarified the deprecated boxqq(), stripqq(), and modcheck() descriptions without restoring exported examples.
- Preserved legacy helper behavior while reducing CRAN-facing example clutter in generated Rd files.
- Regenerated documentation should be produced by devtools::document() during the stage runner.

## s20x 3.2.291

- Refreshed legacy helper documentation so deprecated, unexported functions no longer show direct internal-call examples.
- Replaced older case-study dontrun examples with interactive examples for CRAN-facing documentation hygiene.
- Preserved case-study and deprecated-helper behavior while making the examples clearer for current teaching material.
- Regenerated documentation should be produced by devtools::document() during the stage runner.

## s20x 3.2.290

- Clarified that the default base plotting engine preserves direct teaching graphics while optional ggplot2 engines return reusable plot objects.
- Added guarded examples for optional ggplot2 and GGally plotting engines in normcheck(), eovcheck(), modelcheck(), and pairs20x().
- Kept ggplot2 and GGally usage behind requireNamespace() guards so examples remain compatible when optional packages are unavailable.
- Regenerated documentation should be produced by devtools::document() during the stage runner.
