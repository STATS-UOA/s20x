## Update

This is a feature update from s20x 3.3.0. It makes predict20x() an S3 generic,
adds classed return values with print methods, deprecates 14 exported functions
that the course no longer uses, and fixes a number of bugs. The deprecated
functions still work and give a warning. The demo scripts have been removed, and
Levene's test has been removed from eovcheck(). See NEWS.md for details.

## Test environments

* local macOS, R 4.6.1
* GitHub Actions: Ubuntu with R oldrel-1, release and devel
* R-hub: Linux, Windows and macOS with R-devel, run on the commit before the
  final version number and NEWS.md changes

## R CMD check results

0 errors | 0 warnings | 0 notes

(local `R CMD check --as-cran` on 3.4.0)

## Reverse dependencies

s20x has two reverse dependencies, dafs and WMFM. I searched their code rather
than running their checks. Neither calls a deprecated or removed function, and
WMFM uses only the s20x datasets, which have not changed.
