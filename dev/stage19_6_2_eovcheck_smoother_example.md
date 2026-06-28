# Stage 19.6.2: eovcheck ggplot2 smoother example

This small follow-up changes the optional `eovcheck()` ggplot2 smoother example so it uses the `peru.fit` regression model rather than the oyster one-way ANOVA-style fit.

The oyster model is still used for the object-return and Levene/two-standard-deviation examples, where it remains appropriate. The smoother example now demonstrates smoothing on a continuous fitted-values plot and avoids loess singularity warnings caused by fitting a smoother to two fitted-value groups.
