# Stage 19.5.1 eovcheck ggplot2 polish

- Adjusted the optional ggplot2 `eovcheck()` plot so the two-standard-deviation reference lines are drawn with the same visual weight as the base plot.
- Included the +/- two-standard-deviation values in the y-axis range calculation so the guide lines remain visible when they exceed the residual range.
- Removed the default grey ggplot2 panel styling from the optional engine so the plot is closer to the original base teaching graphic.
- Moved the Levene-test label to the same inset style used by the base plot.
