# Stage 19.3 modelcheck plotting-engine review

Manual Stage 19.3 reviews `modelcheck()` after the Stage 19.1 and 19.2 fixes.

Changes prepared here:

- Keep `engine = "base"` as the default behaviour for teaching diagnostics.
- Rename internal modelcheck ggplot2 helpers and list class to use `_ggplot2_`-style readable names.
- Replace data-frame subsetting inside ggplot2 aesthetic mappings with `.data` pronouns.
- Add a print method for multiple ggplot2 modelcheck plots so printing gives one diagnostic display instead of list structure.
- Add ggplot2 examples for the individual modelcheck diagnostics.
- Update tests for the renamed modelcheck ggplot2 class and add a print-without-warning regression test.
