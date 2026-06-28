# Stage 19.7.1: pairs20x/modelcheck ggplot2 test fixes

This follow-up repairs two omissions found by the strict test suite after the
Stage 19.7 visual-parity pass.

- Add the missing `geom_segment()` ggplot2 import used by the base-like Cook's
  distance plot in `modelcheck(engine = "ggplot2")`.
- Preserve the `pairs20x(engine = "ggplot2")` return-object contract by setting
  `axisLabels = "none"` on the returned GGally plot matrix.
- Keep the Stage 19.7 visual-parity changes intact.
