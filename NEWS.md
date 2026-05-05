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
