# Course book follow-up to s20x 3.4.1

Changes the STATS 20x course book will need once s20x 3.4.1 is available. Nothing here has been applied.

The master copy of the notes is `CourseNotes/Book`, on the `book-import` branch of `STATS-UOA/STATS20x`. `CourseNotes/2023Sem2` is a frozen snapshot. What counts as live is the `child=` list in `CourseBook_Parent.Rnw`. Ignore any file with "Kathy" in its name.

**Wait first.** James's colleague is due to push changes on Monday 9 November 2026. Incorporate those before touching the book, then recheck every line reference below, because they will move.

## Open issues

Tick these off as they are dealt with. Details are in the sections below.

Needs s20x 3.4.1:

- [ ] Replace the 13 `predictGLM()` calls with `predict20x()`.
- [ ] Replace the `predictGLS.R` and MuMIn workaround in Chapter 17 with `predict20x()`.

Can be done at any time after the colleague's push:

- [ ] Check whether the `pred.df` chunk at `H17.Rnw:2163-2164` fails on current R.
- [ ] Remove `options(stringsAsFactors = TRUE)` from `CourseBook_Parent.Rnw:91` and `CaseStudies_Parent.Rnw:94`.
- [ ] Decide what to do about the 15 live `read.csv()` calls that do not set `stringsAsFactors`.
- [ ] `H17.Rnw` footnote says ARMA models are covered in STATS 726 and 786, but `CSH17-1` fits `corARMA(q = 2)`.
- [ ] Fix typos in `H17.Rnw`: "Since will be forecasting" (line 858) and "Calculate predication intervals" (line 2169).
- [ ] Apply the case study spelling and NZ English fixes. See "Spelling" below.
- [ ] Line up the book and package case studies. `CS16_1` is only in the book, and `CS5_2` and `CS6_5` are only in the package.

Decide later:

- [ ] The 2023 to-do list says to replace `cooks20x()` with `which = 4`. If that happens, the `H10.Rnw:617` footnote about 819 and 820 can go. Until then, keep the package's position labels.
- [ ] Add `ma(q)` to `tslm()` before moving the book to it, expected 2028.

## Replace `predictGLM()` with `predict20x()`

There are 13 live calls, recorded on 7 November 2026, and no live `predictCount()` calls. Every call also needs a decision on `digits`, because `predict20x()` rounds to 3 places and `predictGLM()` does not.

| Location | Call | Change needed |
|---|---|---|
| `H13/H13.Rnw:956` | `predictGLM(CRAN.quasigfit, predCRAN.df)` | Add `type = "link"`, because the defaults differ |
| `H13/H13.Rnw:962` | `type = "response"` | Name swap |
| `H14/CSH14-4.Rnw:181` | `PredAfter = ...` | Add `print.out = FALSE` or print deliberately, and use `$frame` |
| `H14/CSH14-4.Rnw:186` | `PredBefore = ...`, marked "don't display these" | Add `print.out = FALSE`, and use `$frame` |
| `H15/H15.Rnw:640` | `type = "link"` | Name swap |
| `H15/H15.Rnw:646` | `type = "response"` | Name swap |
| `H15/H15.Rnw:983` | `type = "response"` | Name swap |
| `H15/H15.Rnw:990` | `6*predictGLM(...)` | `6 * predict20x(...)$frame` |
| `H15/H15.Rnw:1281` | `predn = ...`, then `round(predn, 3)` and `predn[1, 2]` | Add `print.out = FALSE`, and use `$frame` |
| `H15/H15.Rnw:1376` | `bb.pred.intervals = ...` | Use `$frame` for later use |
| `H15/CSH15-2.Rnw:92` | `type = "response"` | Name swap; the package's CS15_2 already uses `predict20x()` |
| `H15/CSH15-3.Rnw:133` | `type = "response"` | Name swap |
| `H15/CSH15-3.Rnw:196` | `Preds = ...`, then `Preds[, 1]` to `Preds[, 3]` | Add `print.out = FALSE`, and use `$frame`; column positions match |

Column names change from `fit`, `lwr`, `upr` to `Predicted`, ` Conf.lower`, `Conf.upper`.

## Chapter 17

`H17.Rnw:2159-2171` sources `predictGLS.R`, which is marked as not working, loads MuMIn for `se.fit`, and works out prediction intervals by hand. Replace this with `predict20x(CO2.gls, pred.df)`, then:

- Remove `library(MuMIn)` from `H17.Rnw:1790` and `:2160`, `CHAPTERS/H17/predictGLS.R`, and `MuMIn` from `s20xNotesHelper.R`, if nothing else needs them.
- Note that `predict20x()` uses a t multiplier where the book uses 1.96, so printed limits will differ slightly.
- Check `H17.Rnw:2163-2164` first. `pred.df` builds `month` as a character column on current R. `predict()` on a `gls` fit failed with "subscript out of bounds" when given character months on the airline data, with or without MuMIn loaded, so this chunk may already fail when rebuilt. `predict20x()` accepts character levels.
- Note that `$frame` holds the fit in column 1, confidence limits in columns 2 and 3, and prediction limits in columns 4 and 5.

The prediction intervals use the same calculation as the book, `sqrt(se^2 + sigma^2)`, so they follow the regression line and do not use recent residuals.

## Spelling

s20x 3.4.1 corrected spelling and US English in the package's case studies. The book's copies still have the same errors. For each word, the package's `inst/case_studies` has the corrected text. Recorded on 7 November 2026, in `CHAPTERS`:

| File | Words |
|---|---|
| `H02/H02.Rnw` | hypothesized |
| `H02/CSH2-1.Rnw` | variabilty |
| `H02/CSH2-3.Rnw` | orignal |
| `H03/CSH3-1.Rnw` | Finaly |
| `H03/CSH3-2.Rnw` | Britian |
| `H05/CSH5-1.Rnw` | predition |
| `H06/CSH6-3.Rnw` | satisified |
| `H07/CSH7-1.Rnw` | correponds, hypothesized |
| `H08/H08.Rnw` | anomolous |
| `H08/CSH8-1.Rnw` | seperately |
| `H08/CSH8-2.Rnw` | iterest |
| `H09/CSH9-1.Rnw` | acheived, comparisions, satified |
| `H09/CSH9-2.Rnw` | coeffcient, insignficant, insignifcant, signficant |
| `H09/CSH9-4.Rnw` | intraction |
| `H09/CSH9-5.Rnw` | libaray, litte, seaonality, weid, Hawai'ian, meters, fall; also add "(northern hemisphere)" after the first "spring" |
| `H09/CSH9-6.Rnw` | Cholestrol |
| `H10/CSH10-1.Rnw` | anomolous, remore, varaiables, baby'sb irthweight |
| `H10/CSH10-2.Rnw` | Rrank |
| `H11/CSH11-3.Rnw` | Oneway |
| `H12/CSH12-1.Rnw` | Paiwise |
| `H12/CSH12-4.Rnw` | Twoway |
| `H14/CSH14-2.Rnw` | expanatory |
| `H14/CSH14-3.Rnw` | Oneway |
| `H15/CSH15-2.Rnw` | predicators |
| `H15/CSH15-3.Rnw` | APPACHE |
| `H15/CSH15-4.Rnw` | repitition |
| `H17/CSH17-4.Rnw` | occuring |

This list only covers errors found in the package's case studies, so it is not a full spellcheck of the book. Doubled words such as "the the" were not searched for in the book.

## Smaller items

- Remove `options(stringsAsFactors = TRUE)` from `CourseBook_Parent.Rnw:91` and `CaseStudies_Parent.Rnw:94`. On R 4.6 it has no effect on `read.csv()` or `data.frame()` and gives a deprecation warning.
- 15 live `read.csv()` calls do not set `stringsAsFactors`, so those columns are character.
- `H10.Rnw:617` teaches that observation 820 shows as 819 in `cooks20x()`. Keep the package's position labels while this stands.

## `tslm()`

James does not expect to move the book to `tslm()` until 2028, when James returns to teaching the course. Before that switch, `tslm()` needs `ma(q)` support, because `CSH17-1` fits `corARMA(q = 2)`.
