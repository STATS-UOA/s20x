# Stage 11 return-convention modernisation plan

## Purpose

Stage 11 has identified that several older teaching helpers combine printed output, plots, and returned objects. This note records a low-risk plan for improving consistency without surprising existing users or changing classroom examples abruptly.

## Current direction

The package should continue to treat long-standing teaching helpers as teaching interfaces, not as drop-in replacements for base R generics. That means modernisation should make behaviour clearer and easier to maintain before changing any return objects.

## Recommended principles

1. Preserve existing visible output unless a later stage explicitly targets one function with regression tests.
2. Preserve existing return shapes until a replacement path has been documented.
3. Prefer documenting invisible returns before converting them to new classes.
4. Add tests around mixed side-effect helpers before refactoring them.
5. Use compatibility wrappers or transitional helpers if a later stage introduces structured return objects.

## Function categories

### Keep as teaching wrappers

These functions intentionally produce teaching-friendly summaries or plots. They should be modernised internally and documented clearly rather than replaced by base-R-style APIs.

Examples include prediction helpers, summary helpers, residual diagnostics, and case-study helpers.

### Candidates for return documentation

Some functions print or plot as their primary effect but also return useful values. These should be reviewed one at a time and documented with explicit `@return` sections before any behaviour change.

Likely candidates include:

- one-way and two-way summary helpers
- contingency-table helpers
- diagnostic plotting helpers
- prediction teaching wrappers

### Candidates for later structured returns

Structured return objects may be useful where a helper currently returns a list or data frame that is hard to interpret. This should be a later stage after tests capture current behaviour.

Potential future approach:

- keep the existing exported function name
- return an object with a small S3 class only if current code already returns an object
- provide `print()` methods that reproduce current visible output
- avoid changing plotting side effects in the same stage

## Suggested next implementation sequence

1. Pick one helper with a simple return value and good existing tests.
2. Add or improve `@return` documentation only.
3. Add regression tests for printed output and returned value.
4. Consider a later structured-return stage only if the current return is demonstrably unclear.

## Out of scope for the next stage

Do not yet:

- introduce broad S3 classes across the package
- change printed output formats package-wide
- replace teaching wrappers with base R generics
- remove legacy exported names
- change plotting side effects

## Stage 11.11 decision

Stage 11.11 should be treated as a planning and guardrail stage. It does not change public behaviour. The next implementation stage should choose one function family and improve return documentation and tests before any deeper refactor.
