# Stage 15 audit report

Scope: static audit of the uploaded Stage 14.6.9 codebase. R was not available in the execution environment, so no roxygen generation, package build, tests, or full check were run.

## Summary

No code was changed. The audit found a small number of narrow follow-up items suitable for Stage 15.1.

## Exported and deprecated diagnostic functions

Current exported functions in `NAMESPACE`: 39.

Diagnostic export status looks consistent with the Stage 15 intent:

- Exported current diagnostic functions: `autocorPlot`, `cooks20x`, `eovcheck`, `modelcheck`, `normcheck`, `residPlot`.
- Not exported deprecated diagnostic helpers: `autocor.plot`, `boxqq`, `stripqq`, `modcheck`.
- Deprecated functions still have generated `.Rd` files and examples using `s20x:::` where relevant.

Notes:

- `modelcheck` remains exported and has `S3method(modelcheck,lm)`.
- `modcheck` is documented as deprecated and no longer exported.
- `autocor.plot` is documented as a deprecated compatibility alias and no longer exported.

## Remaining undocumented internal functions

Static scan found 11 function definitions without a preceding roxygen block:

- `restoreGraphicsParameters` in `R/graphics-parameter-helpers.R`
- `extractTitle` in `R/listCaseStudies.R`
- `parseNumber` in `R/listCaseStudies.R`
- `createLayoutMatrix` in `R/modelcheck.R`
- `qqPlot` in `R/normcheck.R`
- `histPlot` in `R/normcheck.R`
- `panel.hist` in `R/pairs20x.R`
- `panel.cor` in `R/pairs20x.R`
- `getStats` in `R/summaryStats.R`
- local `error` helper in `R/tslm.R`, first occurrence
- local `error` helper in `R/tslm.R`, second occurrence

Recommended Stage 15.1 action: add narrow `@noRd` roxygen blocks for true internals, unless any should be exported or S3-registered.

## Examples against current exports

No obvious examples were found calling a package-internal function directly by bare name. Deprecated examples for `boxqq`, `stripqq`, and `modcheck` use `s20x:::` intentionally.

The naive static scan flagged common base/stats calls such as `log()`, `data.frame()`, `with()`, `within()`, `I()`, `residuals()`, and `table()`, but those are not package export problems.

Potential follow-up checks when R is available:

- Run `tools::checkRd()` or `R CMD check` to confirm examples execute cleanly.
- Confirm examples containing `s20x:::` are acceptable for deprecated unexported functions, or wrap them in `\dontrun{}` if CRAN-style checks object.

## Dataset documentation and installed data objects

Installed `.rda` objects found: 40.

All installed `.rda` datasets have matching documentation aliases, including `nzarrivals.df`.

No documented dataset alias was found without a matching installed `.rda` object.

Follow-up cleanup item:

- `data/.Rapp.history` is present and appears accidental. It should probably be removed from the stage patch.

## Executable `::` usage

No executable `pkg::fun()` calls were found in `R/` after excluding roxygen comments.

Roxygen links such as `[stats::lm()]` were not treated as issues.

## `data-raw/` preference

A `data-raw/` directory is still present with:

- `data-raw/create-nzarrivals-data.R`
- `data-raw/nzarrivals-source.csv`

Recommended Stage 15.1 action: remove `data-raw/` from the patch/package tree, in line with the project preference to generate final package data artifacts directly and include only files needed by the package or stage patch.

## Recommended Stage 15.1 patch scope

Keep this narrow:

1. Remove `data-raw/`.
2. Remove `data/.Rapp.history`.
3. Add `@noRd` roxygen blocks for remaining undocumented internal helpers.
4. Optionally adjust deprecated examples only if check output shows they cause failures or warnings.
5. Regenerate roxygen output with `devtools::document()` or equivalent.
6. Run targeted documentation/example checks when R is available.

## No-change audit result

Because this pass was audit-only and R was unavailable, no replacement code files or patch zip were generated.
