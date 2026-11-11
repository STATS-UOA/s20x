# s20x development status

Last updated: 11 November 2026.

## Where things stand

- `master` is at 3.4.1, merged on 7 November 2026 as PR #12 after CI passed on R oldrel-1, release and devel. CRAN still has 3.4.0.
- Before submitting 3.4.1 to CRAN, run `rhub::rhub_check()` and win-builder; so far it has only been checked on Ubuntu and macOS.
- The course book that uses s20x is in `STATS-UOA/STATS20x`, in `CourseNotes/Book`. Its checklist, including the changes it needs from 3.4.1, is in that repository's `DEVELOPMENT/STATUS.md`.

## Open items

- [ ] Submit 3.4.1 to CRAN after the extra checks.
- [ ] `tslm()` needs `ma(q)` support before the course book moves to it, expected 2028. CSH17-1 in the book fits `corARMA(q = 2)`.
- [ ] `summary2way()` rejects character and ordered factors with "This is not a two-way ANOVA model", although `TukeyHSD()` and `model.tables()` handle both. It is not used in the current book.
- [ ] `summary2way()` comparisons on unbalanced data depend on term order and differ from `lm`, with no warning. Low priority, because the book uses emmeans instead.
- [ ] `displayPairs()` returns nothing when a factor level contains a hyphen, because emmeans wraps such labels in parentheses. No level in the current book has one.
- [ ] Case study 8.2 needs the `dafs` package, which it says in its text.

## Decisions to keep

- Keep `cooks20x()` labelling points by position. `H10.Rnw` in the book teaches that observation 820 shows as 819 after observation 239 is dropped.
- `predict20x()` uses t multipliers for `gls` fits, matching its `lm` method, although the book uses 1.96.
- The live book does not use `summary1way()`, `summary2way()`, `multipleComp()` or `rowdistr()`. Assessments have not been checked, so that is not a reason to deprecate them.
