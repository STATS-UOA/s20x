#' Save graphics parameters for later restoration
#'
#' Captures a graphics-parameter state and returns a closure that restores it.
#' This helper centralises the common `par()`/`on.exit()` pattern used by
#' diagnostic plotting functions.
#'
#' @param ... Graphics parameters passed to [graphics::par()] when
#'   `noReadonly = FALSE`.
#' @param noReadonly Logical; if `TRUE`, save all readonly-safe graphics
#'   parameters using `par(no.readonly = TRUE)`.
#' @return A function that restores the saved graphics parameters and invisibly
#'   returns them.
#' @keywords internal
#' @importFrom graphics par
saveGraphicsParameters = function(..., noReadonly = FALSE) {
  if (noReadonly) {
    savedParameters = par(no.readonly = TRUE)
  } else {
    savedParameters = par(...)
  }

  restoreGraphicsParameters = function() {
    par(savedParameters)
    invisible(savedParameters)
  }

  restoreGraphicsParameters
}
