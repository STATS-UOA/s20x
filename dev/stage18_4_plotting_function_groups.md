# Stage 18.4 plotting function lookup cleanup

Stage 18.4 continues the internal plotting cleanup started in Stage 18.1.

## Scope

- Added `getPlottingFunctions()` as a small internal companion to `getPlottingFunction()`.
- Refactored the ggplot2 modelcheck residual and Cook's-distance builders to retrieve grouped ggplot2 functions through the helper.
- Preserved base graphics as the default engine.
- Preserved optional ggplot2 behavior and package checks.
- Avoided user-facing plotting changes.

## Follow-up candidates

- Apply the grouped lookup helper to `normcheck()` and `eovcheck()` ggplot2 builders after this smaller change has passed validation.
- Keep `pairs20x()` separate until any GGally-specific lookup cleanup is reviewed in isolation.
