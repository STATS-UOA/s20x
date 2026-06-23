# Stage 17.4 README plotting narrative

## Purpose

Stage 17.4 adds a short README section that explains the optional plotting-engine modernisation in package-level language.

## Scope

- Preserve base graphics as the default diagnostic plotting behaviour.
- Document that selected helpers now accept `engine = "ggplot2"` for reusable plot objects.
- Guard README examples with `requireNamespace()` so optional plotting packages are not treated as required.
- Keep this as a documentation-only follow-up to the Stage 16 plotting modernisation and Stage 17 help-page refresh.

## Compatibility

No plotting behaviour or public API is changed in this stage.
