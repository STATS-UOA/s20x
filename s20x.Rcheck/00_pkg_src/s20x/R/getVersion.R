#' s20x pacakge version number
#' 
#' Returns the version number of the s20x package. This is useful if a student
#' is has problems runnning commands and the maintainer needs to check the
#' version number.
#' 
#' 
#' @keywords debugging
#' @examples
#' 
#' getVersion()
#' 
#' @export getVersion
getVersion = function() {
    return(packageDescription("s20x"))
}
