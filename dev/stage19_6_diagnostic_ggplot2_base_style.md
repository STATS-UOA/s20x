# Stage 19.6 diagnostic ggplot2 base-style polish

Stage 19.6 polishes the optional ggplot2 diagnostic plots after manual visual review.

Changes made:

- Added a shared internal `s20x_ggplot2_base_theme()` helper for diagnostic ggplot2 plots.
- Applied the base-like theme to `normcheck()`, `eovcheck()`, and `modelcheck()` ggplot2 outputs.
- Removed the default grey ggplot2 panel background and grid from those diagnostic plots.
- Reduced guide-line widths so zero, normal-curve, smoother, and two-standard-deviation guides are closer to the base graphics teaching plots.
- Changed the `modelcheck()` ggplot2 Cook's distance panel from a connected line plot to vertical observation-wise segments.
- Added tests for the base-like theme and Cook's distance segment geometry.

Base graphics remains the default engine. The ggplot2 engine remains optional and returns reusable plot objects.
