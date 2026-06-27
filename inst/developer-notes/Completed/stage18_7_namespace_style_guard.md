# Stage 18.7 namespace style guard

Stage 18.7 adds a regression guard for the namespace-import repair completed in Stage 18.6.

## Changes

- Replaced the internal-test helper implementation so it avoids `getFromNamespace()` while still retrieving unexported package helpers for tests.
- Added source-tree tests that scan controlled package and test files for namespace operators in executable code.
- Added source-tree tests that scan controlled package and test files for dynamic namespace lookup helpers.
- Kept roxygen comments out of the scan so documentation links such as package help references can remain readable.

## Notes

The guard is intended to protect the project convention that non-base functions should be declared through roxygen imports and used directly, rather than through `::`, `:::`, `getExportedValue()`, or `getFromNamespace()` in controlled code.
