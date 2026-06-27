# Stage 18.3 plotting function lookup cleanup

Stage 18.3 continues the internal plotting cleanup started in Stage 18.1 and
Stage 18.2.

## Scope

This stage centralises dynamic optional plotting function lookup behind
`getPlottingFunction()` in `R/plotting-engine-helpers.R`.

The affected plotting functions still retrieve ggplot2 and GGally functions
only when optional plotting engines are used. The cleanup avoids repeating raw
`getExportedValue()` calls across the individual plotting implementations.

## Behaviour

No user-facing plotting behaviour is intended to change.

- Base graphics remain the default plotting engine.
- ggplot2 and GGally remain optional.
- Existing optional-engine return values are preserved.
- The change is an internal helper cleanup only.

## Files touched

- `R/plotting-engine-helpers.R`
- `R/normcheck.R`
- `R/eovcheck.R`
- `R/modelcheck.R`
- `R/pairs20x.R`
