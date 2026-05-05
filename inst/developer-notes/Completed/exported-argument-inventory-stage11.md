# Stage 11.5 exported argument inventory

This inventory supports Stage 11 API-consistency planning. It is intentionally descriptive and does not change exported interfaces.

## High-confidence compatibility decisions already made

| Area | Current compatibility position |
| --- | --- |
| Prediction helpers | Keep explicit teaching-wrapper names and document that they are not drop-in base `predict()` replacements. |
| `openCaseStudy()` family | Keep `dest_dir`; support `destDir` as a camelCase alias. |
| `casestudy()` family | Keep `output_dir`; support `outputDir` as a camelCase alias. |

## Remaining argument-name patterns to review

| Pattern | Examples | Suggested handling |
| --- | --- | --- |
| Printed-output switches | `print.out`, `show.table`, `verbose` | Document consistently before adding aliases. |
| Data-order switches | `data.order` | Preserve unless there is a broader naming plan. |
| Plot-order switches | `plotOrder`, `which`, `page` | Review with plotting API behaviour, not as a naming-only change. |
| Interval names | `conf.level`, `cilevel`, `interval.type` | Avoid changing deprecated helpers unless tests and documentation make the need clear. |
| Legacy display names | `asDF`, `twosd` | Preserve for compatibility; consider aliases only if users benefit. |

## Stage 11.5 conclusion

The next implementation step should not be another broad alias pass. A better next stage is either:

1. a return-value audit for prediction and summary helpers, or
2. a printed-output/documentation consistency pass for helpers that return invisible values while printing tables or plots.
