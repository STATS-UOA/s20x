# Stage 19.6.1: suppress modelcheck ggplot2 smoothing message

## Scope

Stage 19.6.1 is a narrow follow-up to Stage 19.6.

## Change

- Added an explicit `formula = y ~ x` to the optional ggplot2 residual smoother in `modelcheck()`.
- This keeps the loess smoother unchanged while suppressing the standard ggplot2 message printed when the formula is inferred.

## Expected result

- `print(modelcheck(fit, engine = "ggplot2"))` should run silently in the existing test.
- The Stage 19.6 base-like diagnostic styling and Cook's distance vertical-line plot are preserved.
