# Stage 19.8: pairs20x ggplot2 diagonal y-limits

## Scope

Stage 19.8 continues the Stage 19 optional plotting-engine visual-parity work for `pairs20x(engine = "ggplot2")`.

## Changes

- Adjusted the ggplot2 histogram diagonal panels so their y-limits reserve headroom for the diagonal variable labels, matching the original base pairs-style plot more closely.
- Moved the diagonal label above the histogram bars instead of placing it inside the tallest part of the histogram.
- Added a regression test for the histogram panel y-limit contract.

## Compatibility

- The base graphics engine remains the default.
- The optional ggplot2/GGally engine remains optional and still returns a GGally plot matrix.
