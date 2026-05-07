# Internal graphics-parameter helpers.

saveGraphicsParameters = function(..., noReadonly = FALSE) {
  if (noReadonly) {
    savedParameters = graphics::par(no.readonly = TRUE)
  } else {
    savedParameters = graphics::par(...)
  }

  restoreGraphicsParameters = function() {
    graphics::par(savedParameters)
    invisible(savedParameters)
  }

  restoreGraphicsParameters
}
