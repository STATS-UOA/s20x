# s20x development log

Newest entries first. Each entry says what was done and decided, and why. Release details are in `NEWS.md`.

## 11 November 2026

- Set up `inst/developer-notes/STATUS.md` and this log, so work can be picked up on any computer; Claude's memory does not move between machines. The course book checklist moved to `DEVELOPMENT/STATUS.md` in `STATS-UOA/STATS20x`, where the book now lives.

## 7 November 2026

- CRAN accepted 3.4.0; tagged `v3.4.0` at `9659e32`.
- Reviewed the package against the 2023Sem2 notes and then the master course book. The findings that mattered for the book became 3.4.1: `gls` support in `predict20x()`, `normcheck()` and `eovcheck()`; `tslm` fixes for `confint()`, `sigma()`, constants, `weights` and `subset`; clearer deprecation messages; and the bootstrap guards in case studies 6.3 and 9.2.
- Corrected spelling across the case studies and changed them to NZ English. Removed references to BIOSCI 209, which no longer exists.
- Merged 3.4.1 to `master` as PR #12.

## 5 November 2026

- Fixed the bugs from an earlier package review (the `fix-code-review-bugs` commits), deprecated functions the course no longer uses, and submitted 3.4.0 to CRAN.
