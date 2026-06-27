# Stage 18.2 plotting engine dispatch cleanup

Stage 18.2 continues the internal plotting cleanup from Stage 18.1. The goal is to reduce duplicated engine argument handling without changing user-facing plotting behavior.

## Files inspected

- `R/plotting-engine-helpers.R`
- `R/normcheck.R`
- `R/eovcheck.R`
- `R/modelcheck.R`
- `R/pairs20x.R`
- `.Rbuildignore`

## Cleanup

- Added `matchPlottingEngine()` as the shared internal helper for standard plotting engine matching.
- Replaced repeated `match.arg(engine)` calls in plotting entry points with `matchPlottingEngine(engine)`.
- Left explicit base-versus-ggplot2 dispatch in each exported plotting function so the base graphics default remains visible and easy to audit.
- Added `.s20x_validation_mode` to `.Rbuildignore` so local validation state files are not included in R CMD check tarballs.

## Behaviour and compatibility

- The accepted engine values remain `"base"` and `"ggplot2"`.
- Base graphics remains the default plotting engine.
- ggplot2 and GGally remain optional.
- Teaching-oriented base plotting output is unchanged.

## Deferred cleanup candidates

- Consider a small helper for repeated `getExportedValue()` lookups only if a later stage touches several ggplot2 panel builders at once.
- Consider shared ggplot2 residual data-frame construction only if a later stage changes both `eovcheck()` and `modelcheck()`.
