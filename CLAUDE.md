# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this package is

s20x is a CRAN teaching package for University of Auckland STATS 201/208 and BIOSCI 209. Large classes of mostly non-statistics majors use it, and lecture notes, labs and case studies depend on its exact output. The rule that overrides most others: **student-facing defaults, function names and printed output stay stable**. New behaviour is opt-in, deprecated names get `.Deprecated()` rather than abrupt removal, and changes are small and incremental. Do not reformat or redesign the package wholesale.

## Legacy and future code

The current lecture notes define what is actually used, not the exports, but absence from the notes doesn't make something legacy.

- Levene's test and formal normality tests are no longer taught. Levene's test was removed from `eovcheck()` in 3.4.0, and `levene.test()` and `normcheck(shapiro.wilk = )` are deprecated. Don't spend effort testing or polishing them, and finish removing them only when asked.
- `tslm()` is not in the notes yet, but it will be used in future. Never treat it as legacy or a candidate for removal.

## Commands

The standard `devtools` commands are in the workspace `CLAUDE.md` (the parent folder). These are the s20x specifics:

```sh
Rscript -e 'devtools::test(filter = "tslm")'                 # one file: tests/testthat/test-tslm.R
Rscript scripts/checkRStringEscapes.R                        # fast preflight for bad backslash escapes in R strings
Rscript -e 'rcmdcheck::rcmdcheck(args = c("--no-manual", "--ignore-vignettes"), error_on = "warning")'   # matches CI
```

- `ggplot2` and `GGally` must be installed before `devtools::test()` or `devtools::load_all()` will run. They are hard `Imports`, deliberately, because the no-`::` rule rules out `Suggests`.
- Tests use the built-in datasets. Do not create synthetic data to stand in for them. There is no `LazyData`, so load them explicitly: `data("peru.df", package = "s20x", envir = environment())`.
- CI runs on ubuntu with R oldrel-1, release and devel, and fails on warnings as well as errors.
- `.github/workflows/rhub.yaml` runs R-hub checks on more platforms. It only runs when started, with `rhub::rhub_check()`. Keep using win-builder as well before CRAN submissions.

## Versions and NEWS

This overrides the workspace convention: versions here have three components, not a fourth build component. Edit `DESCRIPTION` by hand after checks pass, because `commitTools::bumpBuildNumber()` is built around the four-part scheme. Increase the last number from the current version for each change, and merge those entries into one before a CRAN release; the middle number moves for the release (`3.3.0` to `3.4.0`). Add a matching `# s20x x.y.z` heading to the top of `NEWS.md`. Every version must use a level-one heading, because pkgdown drops versions at any other level.

## Style rules enforced by tests

- No `::` or `:::` anywhere in the code in `R/` or `tests/testthat/`, and no `getExportedValue` or `getFromNamespace`. Only comments are exempt, so strings count. Instead:
  - Add imports with roxygen `@importFrom`, in the block in `R/s20x-package.R` or next to the function that uses them, then run `devtools::document()`.
  - In tests, reach internals with `getS20xInternal("name")` from `tests/testthat/helper-internal-helpers.R`.
- Every top-level function in `R/model-diagnostic-helpers.R` and `R/tslm.R` needs a roxygen comment, including internal ones (`@keywords internal`).

Not tested, but followed throughout: `=` for assignment, camelCase for new or touched code, braces on all control structures. Apply these only to code you are already changing.

## Architecture

**Plotting engines.** `normcheck()`, `eovcheck()`, `modelcheck()` and `pairs20x()` take `engine = c("base", "ggplot2")`, and `"base"` must remain the default and keep its exact output.
- Each function resolves the engine with `matchPlottingEngine()` (in `R/plotting-engine-helpers.R`), then branches to a `*_ggplot2` helper, for example `normcheck_ggplot2_QQ`.
- The base engine draws on the active device and returns nothing reusable. The ggplot2 engine returns a ggplot object for a single plot, or a named list with an S3 class such as `s20xNormcheck_ggplot2` for several. That class's `print()` method lays the panels out with `grid`. The exception is `pairs20x()`, which returns a GGally `ggmatrix`. See `test-diagnostic-plot-return-contract.R` and `test-pairs20x-engine.R`.
- `modelcheck_ggplot2` reuses `normcheck(x, engine = "ggplot2")`, so normcheck changes reach modelcheck.
- Use `saveGraphicsParameters()` (`R/graphics-parameter-helpers.R`) to restore `par()` state in base plots. ggplot2 output aims to match the base teaching plots visually, via `s20x_ggplot2_base_theme()`.

**`tslm()`** (`R/tslm.R`) wraps a fitted model in a `tslm` S3 list. `parseTslmFormula()` strips any `ar(p)` term from the formula. Without one the fit is `lm`; with one it is `nlme::gls` with `corARMA`. The inner model is `$fit`, and the many S3 methods forward to it. Data may come from `data` or the calling environment, as with `lm()`. AR diagnostics use normalised residuals by default. `normcheck` has a `tslm` method, and `R/model-diagnostic-helpers.R` (`getModelResidualFittedData()`) handles residual extraction shared by the diagnostics.

**Prediction.** `predict20x()`, `predictCount()` and `predictGLM()` are thin wrappers over `R/internal-predict-helper.R`. Their return shapes and column names, including the leading spaces in names such as `" Conf.lower"`, are pinned by `test-predict-api-current-behaviour.R`, so treat those as API.

**Case studies.** `inst/case_studies/CS<chapter>_<n>.Rmd` are shipped and read at runtime through `system.file()`.
- `casestudy()` copies the Rmd to a working directory and renders it in a fresh environment; `openCaseStudy()` copies it for editing; `listCaseStudies()` lists them. Short aliases exist (`cs`, `lcs`, `listCS`, `opencs`, `ocs`).
- Many case studies show a student-facing `read.table()` or `read.csv()` under `eval=FALSE`, with the real load in a hidden chunk, usually `load(system.file("extdata", ...))`. A few use `data()` instead. Keep the displayed and real loads in step.

- Case study code is styled with `styler`. Run `Rscript scripts/styleCaseStudies.R` after editing; a GitHub check fails otherwise. It stops at line breaks so that `=` is kept.

**Data.** `data/*.rda` are the documented datasets (roxygen in `R/s20x-data.R`). `inst/extdata/` holds undocumented files used by the case studies. Existing variables stay as they are to avoid mismatches with lecture notes, so add new variables rather than replacing old ones.

## Repo-specific workflow

- 3.4.0 has been submitted to CRAN (2026-11-05). When James confirms it is accepted, tag `v3.4.0` at the submitted commit (`9659e32`) and remove this note. If CRAN asks for changes, make them first and tag the commit that is accepted.
- Modernisation has been done in numbered stages (`9`, `9.1`, `9.1.1` for fix iterations), driven by `scripts/runStage.sh`, which applies a run script and change-set zip from `~/Downloads`. Past design decisions and audits are in `inst/developer-notes/`, which is excluded from the build. Read these before reworking an area.
- `build/`, `docs/`, `vignettes/articles/`, `Meta/`, `chatgpt-bundles/`, `*.zip`, `.s20x_built_pkg_path` and `.s20x_validation_mode` are generated and git-ignored, so don't edit them. `.s20x_stage*_validation_mode` files are also generated, but `.gitignore` doesn't cover them, so don't commit them.
