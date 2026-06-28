# Stage 19.2: eovcheck optional ggplot2 engine review

Manual review focus:

- Preserve base graphics as the default `eovcheck()` behaviour.
- Keep the optional ggplot2 engine available for reusable plot objects.
- Rename internal ggplot2 helpers to read as `*_ggplot2` rather than `*Ggplot2`.
- Use `.data$` aesthetic mappings so ggplot2 output does not warn about external vectors.
- Add examples showing `engine = "ggplot2"` with smoother, two-sigma, and Levene display options.

