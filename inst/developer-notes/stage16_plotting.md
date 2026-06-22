Stage 16 context: optional ggplot2 modernisation of diagnostic plotting functions

We are modernising the s20x plotting functions, but the original base graphics output is important for teaching and backward compatibility. The safest direction is to make ggplot2 versions optional rather than replacing base graphics outright.

Core design decision:

Use an engine argument on heavily used plotting functions:

engine = c("base", "ggplot2")

The default should be "base" so existing teaching material and visual expectations remain unchanged. The ggplot2 version should be available as an optional modern output.

Functions already discussed or partially converted:

* normcheck()
* eovcheck()
* modelcheck()
* pairs20x()

Current concern:

The ggplot/GGally version of pairs20x() looks too different from the original base pairs() plot. The original plot is a teaching graphic with white panels, cyan histograms, open circles, thin red smoothers, and correlation text whose size is proportional to abs(correlation). GGally defaults introduce grey panels, strips, different smoothing/point styling, progress bars, and histogram bin warnings. If GGally is retained, it needs custom panels and styling to mimic the base output closely. Alternatively, keep the original base implementation as default and add a carefully styled ggplot2/GGally engine later.

Package conventions:

* Use camelCase identifiers.
* Use = for assignment.
* Use braces for all control structures.
* Use roxygen2 documentation.
* Prefer @importFrom over pkg::fun calls.
* Use @rdname instead of @describeIn.
* Keep examples working under devtools::check().
* Do not weaken checks to make documentation pass.

Immediate next step:

Refactor plotting functions to support engine = c("base", "ggplot2"), with base as default, starting with pairs20x(), then revisit normcheck(), eovcheck(), and modelcheck() so the ggplot versions are optional rather than replacements.

As a first step you should provide bash commands to check out a new branch. I am happy for you to suggest a name for the branch. It should 
also be pushed to the remote. You should also ask me to load the current code base. We may also have to update some of my skills before we start development
