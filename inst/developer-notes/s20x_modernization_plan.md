# s20x modernization plan

This plan keeps the first `tslm()` change reviewable while setting up a gradual modernization path.

## Stage 1: add `tslm()` safely

- Add `tslm()` as a small student-facing wrapper around `lm()` and `nlme::gls()`.
- Support formula syntax such as `tslm(y ~ x + ar(1), data = data.df, time = t)`.
- Fit ordinary `lm()` models when no `ar(p)` term is supplied.
- Fit AR(p) error models through `nlme::gls()` and `nlme::corARMA(p = p, q = 0)`.
- Add a small `testthat` setup and unit tests for parsing, `lm()` fallback, unsupported future terms, and AR fitting when `nlme` is installed.

## Stage 2: package infrastructure

- Add continuous integration for `R CMD check` on current R release, oldrel, and devel.
- Add a `NEWS.md` file if one is not already maintained in the repository.
- Add `testthat` coverage incrementally around high-use functions.
- Keep `nlme` in `Suggests` unless you decide AR support should be installed unconditionally.

## Stage 3: documentation cleanup

- Regenerate documentation with the current `roxygen2` version.
- Review examples so they are fast, deterministic, and suitable for CRAN-like checks.
- Consider adding one vignette or article for `tslm()` once the API stabilises.

## Stage 4: code style and compatibility

- Modernise touched files gradually rather than reformatting the whole package at once.
- Prefer `=` assignment, camelCase identifiers, and braces for all control structures in new or edited code.
- Avoid changing long-standing student-facing function names unless there is a compatibility wrapper.
- Mark deprecated aliases explicitly rather than removing them abruptly.

## Stage 5: future `tslm()` extensions

- Add grouped time series support, for example `group = subject`.
- Add clearer residual diagnostics for AR models.
- Reserve parser support for `ma()`, `arma()`, `arima()`, and `sarima()`, but keep them disabled until the teaching need is clear.
- Decide whether `time` should become mandatory for AR models after an initial transition period.
