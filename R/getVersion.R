#' s20x Package Version Number
#'
#' Returns the version number of the s20x package. This is useful if a student
#' has problems running commands and the maintainer needs to check the version
#' number.
#'
#' @keywords debugging
#'
#' @examples
#' getVersion()
#'
#' @export getVersion
getVersion = function() {
  utils::packageDescription("s20x")
}
