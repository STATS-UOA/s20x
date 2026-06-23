# s20x Stage 15 Context

We have just completed Stage 14, which focused on diagnostic plotting internals, roxygen documentation, namespace-import cleanup, `nzarrivals.df`, and related check/test fixes.

## Important preference

Do not use or create `data-raw/`.  
For any future dataset work, generate the final package data artifact directly and include only files needed by the package or stage patch.

## Next workflow

Start with a short audit stage before changing more code.

## Stage 15: audit only

Goals:
  - confirm exported/deprecated diagnostic functions are exactly as intended
- scan remaining undocumented internal functions
- check examples against current exports
- review dataset documentation and installed data objects
- identify remaining `::` usage in executable code only, ignoring roxygen links like `[stats::lm()]`
- do not change code unless the audit clearly identifies a small safe fix
- no version bump or full check needed if the stage is audit-only

## Likely Stage 15.1

Example and documentation consistency cleanup:
  - fix examples that depend on unexported functions
- ensure all documented datasets load correctly
- ensure roxygen links are valid
- ensure imports are declared with `@importFrom`
- avoid manual `NAMESPACE` edits
- keep changes narrow and testable

## Style requirements

Use my R development style skill:
  - `=` assignment
- camelCase names
- curly braces for all control structures
- roxygen2 documentation for all functions, including internal helpers
- `@importFrom` rather than executable `pkg::fun()` calls
- do not remove valid roxygen links such as `[stats::lm()]`
- do not create `data-raw/`
- remove `data-raw`

## Skills
- Use my s20x-stage-script generator skill
- Use my R development style skill
- Use my s20x-merge-script skill when I ask to merge back to the master.