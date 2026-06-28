# Stage 19.6.4 modelcheck ggplot2 geom_text import

Stage 19.6.4 fixes a narrow regression from Stage 19.6.3.

- Add the missing ggplot2 geom_text import used for Cook's distance labels.
- Keep the Stage 19.6.3 modelcheck layout, base-like theme, and Cook's distance display unchanged.
- Preserve the base graphics engine as the default and keep ggplot2 optional.
