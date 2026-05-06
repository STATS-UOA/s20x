# Stage 12 documentation audit

## Scope

Stage 12 focuses on documentation coherence, examples, and teaching narrative. This audit is intentionally documentation-only. It does not recommend public API changes or broad behavioural refactors for Stage 12.1.

The review covered exported help examples, dataset choices, time-series teaching examples, `R CMD check` suitability, and obvious spelling or grammar issues. NZ English is preferred for new or touched package documentation.

## Audit categories

### Keep unchanged for now

These examples already use `s20x` teaching datasets, are short, and appear suitable for ordinary help-page examples:

- `boxqq()` with `zoo.df`.
- `ciReg()` with `peru.df`.
- `cooks20x()` with `peru.df`.
- `crossFactors()` with `arousal.df`.
- `crosstabs()` and `rowdistr()` with `body.df`.
- `freq1way()` with `body.df`.
- `layout20x()` and `summaryStats()` with `course.df`.
- `levene.test()` and `multipleComp()` with `computer.df` or `butterfat.df`.
- `onewayPlot()` and `twosampPlot()` with `computer.df`, `apples.df`, and `oysters.df`.
- `pairs20x()`, `residPlot()`, and simple diagnostic examples with `peru.df`.
- `tslm()` and `anova.tslm()` examples using `beer.df` and `airpass.df`.

These should only need minor wording edits if they are touched for another reason.

### Clarify wording

Several help pages would benefit from clearer teaching narrative rather than behavioural changes:

- `predict20x()` should more directly explain that it is a teaching wrapper around prediction and interval output, not a complete replacement for base `predict.lm()`.
- `tslm()` and `anova.tslm()` should keep distinguishing AR-error modelling from ordinary `lm()` trend models.
- Diagnostic helpers such as `modcheck()`, `normcheck()`, `eovcheck()`, `modelcheck()`, and `trendscatter()` should clarify which examples are synthetic teaching examples and which examples use package datasets.
- Deprecated example forms that use `with()` should use consistent wording, such as "This usage is deprecated", and should not be expanded into new teaching examples.
- `displayPairs()` uses `require(emmeans)` in the example. A later documentation pass should decide whether to wrap this in a conditional example or leave it because `emmeans` is already part of the package workflow.

### Replace example dataset

These examples are candidates for replacement with actual `s20x` teaching datasets:

- `interactionPlots()` currently uses `mtcars`. Replace with `arousal.df`, `course2way.df`, or another package dataset with a two-factor teaching context.
- `modelcheck()` currently uses `x = 1:30` and `y = rnorm(30)`. Replace with a deterministic `s20x` dataset example, probably `peru.df`, unless the synthetic data are needed to demonstrate a specific diagnostic shape.
- `summary1way()` currently constructs a small artificial grouped vector. Replace with `computer.df` or another teaching dataset to align with the rest of the package examples.
- Synthetic examples in `modcheck()`, `normcheck()`, and `trendscatter()` may still be useful for teaching transformations, but they should either be made deterministic with `set.seed()` or replaced by package datasets where the teaching point remains clear.

### Make examples safer or faster for `R CMD check`

The following examples are candidates for small safety improvements:

- Add `set.seed()` to examples that use `rnorm()` if the synthetic examples are retained.
- Keep examples short and avoid large plots or repeated plot sequences where one example is enough.
- Consider whether examples requiring optional or suggested packages should be guarded with `if (requireNamespace(..., quietly = TRUE))`.
- Keep `casestudy()`, `openCaseStudy()`, and `listCaseStudies()` examples inside `\dontrun{}` because they can open files, copy case-study resources, or depend on local interactive behaviour.

### Time-series examples

The core time-series examples use actual time-series teaching datasets:

- `autocorPlot()` uses `airpass.df`.
- `eovcheck()` includes an `airpass.df` time-series example.
- `tslm()` and `anova.tslm()` use `beer.df` and `airpass.df`.

No example was identified in this first audit as clearly pretending that non-time-series data are time series. Later passes should still check generated `man/*.Rd` files after roxygen regeneration, because the source roxygen comments are the canonical files to edit.

### Spelling, grammar, and NZ English

Use NZ English in new or touched documentation. Initial spelling and wording observations:

- Existing public documentation uses `color` in argument descriptions for plotting colour arguments. When touched, prefer `colour` in prose while preserving argument names such as `col`.
- Developer notes include historical files named with `modernization`. Do not rename those files in Stage 12 because that would be noisy and outside documentation coherence for public help pages.
- Some examples use compact comments such as `##body image data:` or inconsistent spacing around formulas. These are minor grammar/style candidates for later roxygen updates.
- Prefer complete teaching sentences in descriptions and details, especially where a function differs from ordinary base R behaviour.

## Recommended next sub-stages

### Stage 12.2: interaction plot examples

Replace the `interactionPlots()` `mtcars` examples with an `s20x` teaching dataset. This is a small, coherent documentation change and should not alter runtime behaviour.

### Stage 12.3: deterministic diagnostic examples

Review `modcheck()`, `normcheck()`, `modelcheck()`, and `trendscatter()` examples. Add `set.seed()` where synthetic examples are retained, and replace generic examples with package datasets where doing so preserves the teaching point.

### Stage 12.4: prediction and AR-error teaching narrative

Tighten wording in `predict20x()`, `tslm()`, and `anova.tslm()` to clarify wrapper behaviour and AR-error modelling. Keep the existing API and return behaviour unchanged.

### Stage 12.5: summary helper examples

Replace artificial `summary1way()` example data with a package dataset and check related summary helper wording for coherence.

## Deferrals

- Do not redesign prediction helper return objects in Stage 12.
- Do not change diagnostic plotting behaviour unless a documentation problem exposes a small, obvious bug.
- Do not rename legacy files solely for spelling consistency.
- Do not remove deprecated examples unless a later stage creates a formal deprecation plan.

## Stage 12.2 follow-up

Stage 12.2 addressed the first recommended sub-stage by replacing the `interactionPlots()` examples that used `mtcars` with the package teaching dataset `arousal.df`. It also corrected the `fac2` argument description and standardised the deprecated vector-form example note. No plotting behaviour or public API was changed.


## Stage 12.3 follow-up

Stage 12.3 addressed deterministic diagnostic examples. The synthetic teaching examples in `modcheck()`, `normcheck()`, and `trendscatter()` now set a seed before generating random values, while `modelcheck()` now uses the `peru.df` teaching dataset instead of unrelated random data. This stage also corrected small spelling and grammar issues in the touched diagnostic documentation, including Q-Q wording, Cook's distance wording, and NZ English prose where argument names were unaffected. No diagnostic plotting behaviour or public API was changed.

## Stage 12.4 strict NZ English and grammar pass

Stage 12.4 applies a strict NZ English and grammar normalisation pass to touched
public documentation and case-study prose. It also accepts `"normalised"` as a
package-owned alias for the existing `"normalized"` residual type in `tslm`
diagnostics, while preserving `"normalized"` for backward compatibility.

Code-facing identifiers, argument names, external API values, dataset column
names, and generated Rd files are intentionally excluded from direct prose
normalisation. Generated Rd files should continue to be produced by
`devtools::document()`.

## Stage 12.5 summary helper examples

Stage 12.5 addresses the summary-helper example candidates identified in the
audit. The `summary1way()` help example now uses the `computer.df` teaching
dataset instead of artificial grouped vectors, and the `summaryStats()` matrix
example now uses columns from `course.df` instead of random values. Related
summary-helper wording was tightened for grammar, clarity, and consistency with
NZ English, without changing function behaviour.

## Stage 12.6 prediction and AR-error teaching narrative

Stage 12.6 returns to the prediction and AR-error narrative item identified in
the original audit. The prediction helper documentation now more clearly states
that `predict20x()`, `predictGLM()`, and `predictCount()` are compatibility
teaching wrappers rather than drop-in replacements for base `predict()` methods.
The `tslm()` and `anova.tslm()` documentation now further clarifies that `ar(p)`
specifies an error-correlation structure, not an additional mean-model term, and
that AR-error ANOVA output should not be read as an ordinary independent-error
ANOVA decomposition. No prediction, fitting, or ANOVA behaviour is changed.

## Stage 12.7 optional example dependency guard

Stage 12.7 addresses the optional-package example noted in the original audit.
The `displayPairs()` help example now uses `requireNamespace("emmeans",
quietly = TRUE)` and qualifies the `emmeans::emmeans()` call, so the example
remains useful when `emmeans` is installed but is safe in environments where
the suggested package is unavailable. No displayPairs behaviour is changed.

## Stage 12.8 cross-help terminology consistency

Stage 12.8 standardises terminology across closely related diagnostic help
pages. The affected documentation now consistently refers to residuals versus
fitted values, normal Q-Q plots, model checking plots, and plotting side effects.
This is a wording-only pass for public help pages and README text; diagnostic
calculations, plotting behaviour, and public APIs are unchanged.

