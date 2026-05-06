#' s20x package version number
#'
#' Returns the version number of the s20x package. This is useful if a student
#' has problems running commands and the maintainer needs to check the version
#' number.
#'
#' @keywords debugging
#' @examples
#'
#' getVersion()
#'
#' @importFrom utils packageDescription
#'
#' @export getVersion
getVersion = function() {
  packageDescription("s20x")
}
