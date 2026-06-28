# Stage 19.7 pairs20x ggplot2 visual parity

Manual review compared `pairs20x(peru.df)` with `pairs20x(peru.df, engine = "ggplot2")`.

Changes made:

- Removed GGally strip labels from the optional ggplot2 matrix so the layout is closer to the base `pairs()` display.
- Added the variable names inside the diagonal histogram panels, matching the original teaching graphic more closely.
- Tightened the matrix spacing and used white panels with thin black borders.
- Changed the scatter panels to use open diamond points and thinner loess lines.
- Matched the histogram bin breaks to base `hist()` breaks while still drawing the histogram with ggplot2.
- Rescaled correlation text so small absolute correlations become very small, matching the visual emphasis in the base panel.
- Added tests for the base-like GGally matrix settings and small-correlation text scaling.
