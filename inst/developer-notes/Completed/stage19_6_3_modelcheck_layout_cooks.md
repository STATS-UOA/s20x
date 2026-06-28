# Stage 19.6.3 modelcheck ggplot2 layout and Cook's distance polish

- Restored the optional `modelcheck(..., engine = "ggplot2")` multi-plot print layout so it follows the original base teaching layout: residuals across the top, Q-Q and histogram side by side, and Cook's distance across the bottom.
- Updated the ggplot2 Cook's distance panel to label the same high Cook's distance observations that the base diagnostic plot highlights.
- Kept the base graphics engine as the default and preserved the optional ggplot2 object-return contract.
