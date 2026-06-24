We are working on the s20x package modernisation.

Stage 17 is complete. It focused on documentation/example refresh after the optional plotting-engine work from Stage 16. The plotting documentation now covers normcheck(), eovcheck(), modelcheck(), and pairs20x(), including base graphics as the default and optional ggplot2/GGally engines where relevant. README/package-level plotting guidance and optional dependency wording have also been refreshed. Stage runner scratch files were also protected from R CMD check via .Rbuildignore.

Next planned stage: Stage 18.

Stage 18 should focus on internal plotting cleanup, not user-facing behaviour changes.

Start with Stage 18.1: audit duplicated plotting helper logic.

Goals for 18.1:
- Inspect plotting-related R files.
- Identify duplicated data-preparation, residual-checking, theme/layout, and engine-dispatch logic.
- Do not change behaviour unless there is an obvious safe cleanup.
- Preserve base graphics as the default.
- Preserve existing teaching-oriented output.
- Keep ggplot2/GGally optional.
- Follow James's s20x style: = assignment, camelCase identifiers, braces on all control structures, roxygen2 docs, @importFrom rather than pkg::fun().
- Use small, staged, reviewable changes.
- Generate a changes zip and a wrapper-compatible runner named run_s20x_stage18_1.sh.
- The runner must work with scripts/runStage.sh, which calls:
  bash "$scriptPath" --install-files "$changesZip"