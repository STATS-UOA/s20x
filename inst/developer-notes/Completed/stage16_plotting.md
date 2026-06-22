Stage 16 completion note: optional ggplot2 modernisation of diagnostic plotting functions

Stage 16 modernised selected s20x plotting helpers by adding optional ggplot2-style plotting engines while preserving the original base graphics output as the default teaching interface.

Core design decision:

Use an engine argument on heavily used plotting functions:

engine = c("base", "ggplot2")

The default remains "base" so existing teaching material, examples, and visual expectations remain unchanged. The ggplot2 engine is optional and is used only when explicitly requested.

Completed Stage 16 work:

* Stage 16.1 added optional engine support to pairs20x().
* Stage 16.2 added optional engine support to normcheck().
* Stage 16.3 added optional engine support to eovcheck().
* Stage 16.4 added optional engine support to modelcheck().
* Stage 16.5 refined pairs20x(engine = "ggplot2") to use a more base-like white theme.
* Stage 16.6 archived this developer note as completed Stage 16 context.

Compatibility position:

* Base graphics output remains the default for all Stage 16 functions.
* Existing calls without an engine argument should retain their previous behavior.
* Optional ggplot2 output should be requested explicitly with engine = "ggplot2".
* Optional plotting dependencies should remain in Suggests rather than Imports unless later package design requires otherwise.

Package conventions used during Stage 16:

* Use camelCase identifiers.
* Use = for assignment.
* Use braces for all control structures.
* Use roxygen2 documentation.
* Prefer @importFrom over pkg::fun calls.
* Use @rdname instead of @describeIn.
* Keep examples working under devtools::check().
* Do not weaken checks to make documentation pass.

Future follow-up ideas:

* Visually compare the optional ggplot2 outputs with the original teaching plots in real teaching examples.
* Continue to refine pairs20x(engine = "ggplot2") only if visual differences materially affect teaching use.
* Avoid replacing base graphics defaults unless a future stage explicitly chooses to make a breaking change.
