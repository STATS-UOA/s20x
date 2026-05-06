# Stage 11 completion plan

## Purpose

Stage 11 focused on API consistency and legacy-code review without broad behavioural refactoring. The work deliberately avoided turning teaching helpers into a new object system or replacing established student-facing interfaces in one step.

## Completed Stage 11 themes

### Prediction teaching wrappers

`predict20x()`, `predictGLM()`, and `predictCount()` were reviewed as teaching wrappers rather than drop-in replacements for base R `predict()` methods. The package now has clearer documentation and shared internal helper structure for prediction and interval arithmetic, while preserving existing public names, arguments, scale conventions, printed output, and return shapes.

### Case-study helper compatibility

Case-study helpers gained compatibility aliases for newer camelCase path arguments while retaining the legacy argument names used in existing teaching material.

### Legacy and deprecation wording

Legacy-helper documentation was standardised to avoid implying abrupt removal where no replacement plan has been agreed. Older helpers can remain available while later stages decide whether they should be modernised, documented as legacy, or deprecated more formally.

### Printed-output and invisible-return conventions

The main teaching-output helpers were reviewed and documented as side-effect-oriented functions that print or plot teaching output while preserving their existing invisible return values. Regression tests now protect those current return shapes before any later modernisation changes them.

## Deferred work

### Stage 12 documentation coherence

Stage 12 should focus on user-facing documentation and examples. Good candidates include:

- Review examples for modern teaching relevance.
- Prefer package teaching datasets where appropriate.
- Remove or revise examples that are technically correct but pedagogically dated.
- Clarify where `s20x` teaching wrappers intentionally differ from base R functions.

### Stage 13 and later internal refactors

Later stages can consider deeper internal cleanups, such as:

- Further extraction of shared plotting and summary helpers.
- More systematic print/summary methods where return objects justify them.
- Deprecation wrappers for helpers that are clearly obsolete after documentation review.
- Reducing duplicated base-graphics setup code.

## Stage 11 recommendation

After the Stage 11.17 completion note, Stage 11 can be considered complete unless the strict checks reveal a specific issue. The next planned work should move to Stage 12 rather than continuing to add small API changes without a broader documentation review.
