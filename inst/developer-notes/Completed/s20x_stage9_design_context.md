# s20x Stage 9 design context

## Purpose

Stage 9 begins the broader `s20x` package modernisation phase after the `tslm()` teaching-interface work. The goal is infrastructure and package hygiene, not behavioural refactoring.

## Starting point

The previous modernisation branch was merged back into `master`, but the branch has not been deleted.

Before starting Stage 9, resume the branch from the newly merged `master` state.

## Git startup commands

Run these from the `s20x` repository:

```bash
git status
git checkout master
git pull --ff-only
git checkout feature-modernisation-phase
git merge --ff-only master || git merge master
git status
```

If the branch should be a fresh branch instead of continuing the old one, use:

```bash
git checkout master
git pull --ff-only
git checkout -b feature-stage9-infrastructure
```

Recommended default: continue using `feature-modernisation-phase` unless there is a reason to keep Stage 9 separate.

## Stage number

Use:

```text
Stage 9
```

Files should be named:

```text
s20x_stage9_changes.zip
run_s20x_stage9.sh
stage9_completed.zip
```

If Stage 9 needs error-fix iterations, use:

```text
9.0.1 or 9.1.1 only if there is a planned sub-stage first
```

Prefer:

```text
9.1, 9.1.1, 9.1.2
```

when Stage 9 is split into named sub-stages.

## Stage 9 scope

Stage 9 should focus on package infrastructure and reliability.

Primary goals:

1. Add GitHub Actions for package checks.
2. Review and tidy package metadata.
3. Add or update `NEWS.md` if needed.
4. Keep all changes non-behavioural.
5. Ensure the existing strict local stage workflow still passes.

## Proposed Stage 9 steps

### Step 1: inspect package metadata

Review:

- `DESCRIPTION`
- `.Rbuildignore`
- existing CI files, if any
- `NEWS.md`, if present
- repository root files such as `README`, `LICENSE`, or `.github`

Look for:

- missing or stale metadata
- missing `Encoding`
- missing or outdated `Roxygen` notes
- dependencies that should be in `Imports` versus `Suggests`
- files that should be ignored by `R CMD build`

Do not make broad dependency changes unless clearly justified.

### Step 2: add GitHub Actions check workflow

Add a conservative workflow such as:

```text
.github/workflows/R-CMD-check.yaml
```

Suggested matrix:

- current R release
- old release
- devel if practical

Suggested operating systems:

- Ubuntu as the primary check platform
- optionally Windows and macOS later, if needed

For Stage 9, it is acceptable to start with Ubuntu only if a smaller, safer first infrastructure change is preferred.

The workflow should:

- use standard R package check actions
- install package dependencies
- run `R CMD check`
- avoid unnecessary external services
- avoid workflows that require secrets

### Step 3: update `.Rbuildignore`

Ensure CI and development-only files do not enter package builds.

Likely entries include:

```text
^\.github$
^.*\.Rproj$
^\.Rproj\.user$
```

Only add entries that are actually needed.

### Step 4: add or update `NEWS.md`

If no `NEWS.md` exists, add a simple one.

Suggested initial structure:

```markdown
# s20x development version

## Modernisation

- Added package infrastructure for automated checks.
```

If `NEWS.md` already exists, append a concise development-version note instead of rewriting history.

### Step 5: tests and checks

No new behavioural tests are expected unless a metadata or helper change needs one.

The strict stage script should still run:

```bash
Rscript -e 'options(warn = 2); devtools::document()'
Rscript -e 'options(warn = 2); devtools::test(stop_on_failure = TRUE, stop_on_warning = TRUE)'
Rscript -e 'options(warn = 2); devtools::check(args = c("--no-manual", "--ignore-vignettes"), error_on = "note")'
```

If the Windows clock NOTE appears again, use:

```bash
export _R_CHECK_SYSTEM_CLOCK_=0
scripts/runStage.sh 9
```

or one-shot:

```bash
_R_CHECK_SYSTEM_CLOCK_=0 scripts/runStage.sh 9
```

## Out of scope for Stage 9

Do not include:

- package-wide style rewrites
- user-facing API changes
- modelling changes
- broad example rewrites
- `tslm()` behavioural changes
- new datasets
- large documentation restructuring

Those belong in later stages.

## Suggested Stage 9 commit message

```text
Add package infrastructure for automated checks

- Add a GitHub Actions workflow for automated R CMD check runs
- Update package build ignores for repository-only infrastructure files
- Add or update development NEWS notes for the modernisation phase
- Keep Stage 9 focused on infrastructure with no user-facing API changes
- Validate with the strict staged document, test, check, build, and install workflow
```

## Information to provide in the next chat

Upload or provide the latest Stage 8.2.1 ChatGPT bundle if available.

Also mention:

- the current branch name: `feature-modernisation-phase`
- Stage 9 should use the `s20x` stage workflow, not the `wmfm` workflow
- the package should continue to follow James's R style conventions

