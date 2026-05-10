# s20x Stage 14 chat context

## Purpose of the new chat

Continue the staged modernisation of the `s20x` package in a new chat, beginning with Stage 14.

Stage 13 has completed the prediction-wrapper internal maintenance stream. Stage 14 should focus on diagnostic and plotting internals, beginning with an audit before implementation.

## Current project state

Recently completed stages:

- Stage 12: documentation coherence, examples, teaching narrative, NZ English, and final documentation wrap-up.
- Stage 13: prediction-wrapper internal audit and targeted maintenance.

The latest completed stage is:

```text
Stage 13.6
```

At the end of Stage 13.6, the recommended workflow was to merge:

```text
predict-internal-audit
```

into:

```text
master
```

then begin the next feature branch:

```text
diagnostic-plotting-internal-audit
```

## Stage 13 completion summary

Stage 13 deliberately remained narrow and focused on prediction-wrapper internals.

Completed work included:

- Stage 13.1: prediction-wrapper internal audit note.
- Stage 13.2: shared internal `newdata` validation for prediction wrappers.
- Stage 13.3: shared interval-output formatting helper work.
- Stage 13.4 and 13.4.1: prediction return-shape alignment and fixes.
- Stage 13.5 and 13.5.1: regression coverage wrap-up for prediction-wrapper compatibility behaviours.
- Stage 13.6: close-out developer note for the prediction-internals stream.

The prediction stream should now be treated as complete unless later diagnostic work reveals a small, directly related issue.

## Recommended Stage 14 scope

Stage 14 should focus on targeted diagnostic and plotting internals.

Recommended start:

### Stage 14.1: diagnostic/plotting internal audit

Create or update a tracked developer note, for example:

```text
inst/developer-notes/stage14-diagnostic-plotting-audit.md
```

The audit should review diagnostic and plotting internals without implementing broad changes.

Likely areas to inspect:

- diagnostic plotting wrappers
- residual and fitted-value helper internals
- layout and graphical-parameter handling
- repeated plot setup/restore logic
- hidden assumptions about model classes
- return conventions for diagnostic helpers, especially whether helpers return values invisibly
- tests covering diagnostic wrappers and plotting side effects

Suggested audit categories:

- keep unchanged
- consolidate duplicated helper logic
- clarify internal naming
- add targeted regression tests
- defer because behaviour/API risk is too high

### Stage 14.2 and later

Implement one narrow diagnostic or plotting internal improvement at a time. Prefer small, reviewable changes over broad rewrites.

Possible later targets:

- common graphical-parameter save/restore helper
- targeted tests for plot wrapper side effects
- common residual/fitted extraction helper if duplication exists
- consistency checks for invisible return values
- documentation clarification only where user-visible behaviour is already established

## Explicit Stage 14 boundaries

Do not:

- redesign public APIs
- rename exported functions
- remove compatibility aliases
- alter user-visible teaching output unless intentional and tested
- make broad diagnostic plotting refactors before the audit is complete
- manually edit `NAMESPACE`; rely on roxygen2
- change graphical behaviour without targeted visual/side-effect regression tests where possible

Behaviour changes should be small, deliberate, backward-compatible where possible, and covered by tests.

## Workflow and artifacts

Continue the staged workflow.

For each planned Stage 14 sub-stage, provide only these two files:

```text
s20x_stage14_1_changes.zip
run_s20x_stage14_1.sh
```

Do not also provide alternate run-script names.

The user has a generic helper:

```bash
scripts/runStage.sh 14_1
```

For implementation stages, the run script should:

1. optionally install the change-set zip
2. run `devtools::document()` with warnings as errors
3. run strict tests
4. run strict check
5. bump `DESCRIPTION` only after checks pass
6. commit with a focused ASCII commit message
7. create `stage14_1_completed.zip` using `git archive`, not `zip .`
8. build the package and capture the exact built tarball path
9. install that exact built package
10. create the compact ChatGPT bundle if `scripts/makeChatgptBundle.R` is available

For notes-only stages with no code, documentation, test, `DESCRIPTION`, or `NAMESPACE` effects, the run script may skip:

- `devtools::document()`
- tests
- check
- version bump
- build/install

It should still install the change-set zip if requested, commit tracked note changes, create the completed archive with `git archive`, and create the compact ChatGPT bundle if available.

Important archive rule:

Use `git archive` for completed zips. Do not use `zip -qr stageN_completed.zip .`, because that can recursively include old completed zips and huge archives.

## Script portability note

Generated scripts must be Windows/Git Bash-safe.

Avoid:

- Python for zip validation or extraction
- BSD-only `stat -f`
- commands that assume macOS-only behaviour

Use Rscript or portable shell where needed.

## Branch and repository notes

The previous working branch was:

```text
predict-internal-audit
```

After merging, the next working branch should be:

```text
diagnostic-plotting-internal-audit
```

Stage scripts should be branch-agnostic and commit to the currently checked-out branch.

## James's R development conventions

Use the user's `r-development-style` skill.

Key conventions:

- Use `=` for assignment, not `<-`.
- Use camelCase identifiers for new or touched code.
- Use styleR-style formatting.
- Always use braces for control structures, even single-line branches.
- Use the native pipe `|>` where useful, not magrittr.
- Keep changes targeted.
- Do not manually edit `NAMESPACE`; rely on roxygen2.
- Prefer `@importFrom` in roxygen documentation where imports are needed.
- Tests should be deterministic, offline, and fast.
- Preserve backward compatibility unless there is a strong reason not to.

## Developer notes location

Use tracked developer notes here:

```text
inst/developer-notes/
```

The repository should include this `.Rbuildignore` entry so developer notes do not enter package builds:

```text
^inst/developer-notes$
```

Do not use `dev/` for tracked notes because `dev/` is ignored in this repository.

## NEWS and versioning convention

Each implementation stage script bumps `DESCRIPTION` after checks pass.

Continue the recent pattern:

- update `NEWS.md` to the expected post-stage version before the script bump
- inspect the current `DESCRIPTION` and `NEWS.md` from the uploaded archive before deciding the exact NEWS heading

Notes-only stages do not need a version bump or NEWS entry unless the note itself is release-relevant.

## Preferred response pattern

For each stage, provide:

- a short change-notes section
- the two artifact links
- the run command

Example:

```text
Stage 14.1 is ready.

Files:

- s20x_stage14_1_changes.zip
- run_s20x_stage14_1.sh

Run:

scripts/runStage.sh 14_1
```

Keep stage commit messages focused on the current planned sub-stage. Only accumulate commit-message history across error-fix iterations such as `14.1.1` and `14.1.2`, not across completed planned stages like `14.1` and `14.2`.
