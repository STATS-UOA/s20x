# Stage 11 printed-output and invisible-return audit

## Purpose

This note records a deeper Stage 11 API concern: many `s20x` teaching helpers intentionally print tables, messages, or plots while returning values invisibly. That behaviour is part of the teaching interface, even when it differs from modern tidy or base-R conventions.

Stage 11 should therefore avoid treating return-shape consistency as a purely mechanical cleanup. Printed output and invisible returns should be modernised only after the current behaviour is documented and protected by tests.

## Current patterns to preserve carefully

### Prediction helpers

The prediction helpers have already been reviewed separately. They intentionally differ from base `predict()` methods by providing teaching-focused printed output, rounded intervals, or response-scale summaries. These should not be reshaped until the teaching goal is explicit.

### Summary helpers

Several summary helpers print teaching tables and return either the printed object, an underlying object, or an invisible value. For these helpers, the printed column names and labels may be more important to users than the formal return value.

Recommended handling:

- add regression tests before changing printed labels;
- avoid switching to tidy-style return values in Stage 11;
- document invisible return values where they are currently unclear;
- prefer small helper extraction over output redesign.

### Model-check and plotting helpers

Model-check helpers often prioritise side effects such as diagnostic plots. Their return values may be incidental. These functions should be reviewed as teaching workflows rather than as pure computational APIs.

Recommended handling:

- preserve plot order and labels unless there is a documented problem;
- avoid changing graphical defaults as part of API consistency;
- add tests only for non-graphical decision logic where practical;
- leave larger plotting redesign for a later documentation or refactor stage.

## Stage 11.10 conclusion

The next API-consistency implementation stage should not broadly change return values. A safer next step is to pick one helper family and document or test its current printed-output behaviour before considering any user-facing change.

Strong candidates for a later sub-stage are:

1. summary helper return-value documentation;
2. model-check helper plot and message documentation;
3. legacy helper deprecation wording where the current replacement is already clear.
