# Stage 18.5 plotting lookup cleanup

Stage 18.5 continues the internal plotting cleanup work from Stage 18.4.

## Scope

- Updated the ggplot2 builders in `normcheck()` and `eovcheck()` to use grouped optional-package function lookup through `getPlottingFunctions()`.
- Kept the ggplot2 package availability checks in the same places as before.
- Preserved base graphics as the default engine.
- Preserved the existing optional ggplot2 behaviour and returned plot objects.

## Files reviewed

- `R/normcheck.R`
- `R/eovcheck.R`
- `R/plotting-engine-helpers.R`

## Follow-up

- Review `pairs20x()` separately because it uses GGally-specific function lookup rather than plain ggplot2 builders.
