# Stage 19.4 pairs20x plotting-engine review

Stage 19.4 completes the Stage 19 manual review sequence for the optional plotting-engine work.

Scope:

- Review `pairs20x()` as the final plotting function in the Stage 19 manual test set.
- Preserve `engine = "base"` as the default so existing teaching graphics remain unchanged.
- Keep the optional `engine = "ggplot2"` path using `ggplot2` and `GGally` for reusable plot matrices.
- Apply the Stage 19 naming polish so internal ggplot2 helper names read as `_ggplot2` rather than `Ggplot2`.
- Keep the existing example showing how to request the optional ggplot2/GGally engine.
- Keep the existing tests covering the base default, engine validation, and GGally return class.

Notes:

- This stage does not change the base plotting implementation.
- This stage does not change the user-facing `engine = "ggplot2"` argument value.
- The helper renaming is internal only and is intended to improve code readability.
