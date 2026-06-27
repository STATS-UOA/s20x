# Stage 18.6 namespace import repair

Stage 18.6 repairs the Stage 18 plotting cleanup so non-base plotting
functions follow the package import convention rather than dynamic namespace
lookup.

## Changes

- Removed the `getPlottingFunction()` and `getPlottingFunctions()` helpers.
- Replaced ggplot2 and GGally dynamic function lookups with direct function
  calls backed by roxygen `@importFrom` declarations.
- Added ggplot2 and GGally to `Imports` because imported namespace functions
  are no longer optional at load time.
- Replaced test `s20x:::` calls with a shared `getS20xInternal()` helper based
  on `getFromNamespace()`.
- Removed the remaining `stats::sigma()` test call.
- Updated the namespace-style compliance test so it does not contain the literal
  namespace operator in the test code.

## Compatibility notes

- Base graphics remains the default plotting engine.
- The ggplot2 engine paths should produce the same plot objects as before, but
  now use imported functions rather than retrieved function objects.
- Because imported functions are declared in `NAMESPACE`, ggplot2 and GGally have
  been moved from `Suggests` to `Imports`.

## Validation notes

- R was not available in the artifact-generation environment, so syntax checks,
  roxygen regeneration, tests, and package check must be run by the stage runner.
