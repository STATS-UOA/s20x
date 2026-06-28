# Stage 19.5: normcheck ggplot2 density curve polish

Stage 19.5 is a small visual polish fix for the optional ggplot2 normcheck histogram.

The histogram remains a native ggplot2 histogram, but the overlaid normal density is now drawn from an explicit data frame over the same x-range used by the plot. This prevents the dotted normal curve from stopping before the displayed histogram range when ggplot2 trains the function layer over a narrower span.

No base graphics behaviour changes.
