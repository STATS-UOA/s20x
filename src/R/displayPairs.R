#' Display within-level pairwise comparisons for saturated two-way ANOVA model.
#'
#' Displays within-level pairwise comparisons from a two-way ANOVA with
#' interactions.  Note that this is just a display function: it ignores any
#' cross-level pairs included in \code{allpairs}, even though these will have
#' contributed to the computations for the Tukey adjustments. The purpose is
#' just to organise the output from \code{emmeans} into a more convenient
#' format.
#'
#' @param allpairs pairwise output from a command like \code{pairs}. See details for a longer explanation.
#' @param levels1 a character string specifying which within-level comparisons from \code{factor1} are wanted, and in which order.
#' @param levels2 a character string specifying which within-level comparisons are wanted, and in which order.
#' @param brief either \code{TRUE} or \code{FALSE}. If \code{TRUE} then the information displayed will be more succint.
#'
#' @details \code{alppairs} is a pairwise output from a command like
#'   \code{pairs(emmeans(fit, ~factor1 * factor2))}. If \code{allpairs} is not
#'   already a \code{data.frame} it will be converted to a \code{data.frame}
#'   within this function.  It must contain a column called \code{contrast} with
#'   text descriptions like \code{'lev1 lev2 - lev3 lev4'} etc. \code{levels1}
#'   and \code{levels2} are character strings specifying which within-level
#'   comparisons are wanted, and in which order. They must match the order
#'   specified in \code{emmeans}, so if using \code{emmeans(fit, ~factor1 *
#'   factor2)} then \code{levels1} must belong to \code{factor1} and
#'   \code{levels2} must belong to \code{factor2}. All this function does is to
#'   pick out the rows of \code{allpairs} with the requested contrasts, so if there are
#'   no contrasts of the requested format (e.g. because \code{levels1} and \code{levels2} have
#'   been switched) it will output a blank list. If \code{brief = TRUE}, columns 
#'   labelled \code{df}, \code{SE}, and \code{t.ratio} will be removed for a more succinct display.
#' 
#' @export
#'
#' @examples
#' ## Fit a two-way ANOVA to the arousal data in arousal.df.
#' ## The factors are gender (female, male) and picture shown to 
#' ## subject (infant, landscape, nude.f, nude.m):
#' data(arousal.df)
#' arousal.fit = lm(arousal ~ gender *  picture, data = arousal.df) 
#' 
#' ## Create a data-frame with all pairwise comparisons using \code{emmeans}: 
#' require(emmeans)
#' arousal.allpairs = pairs(emmeans(arousal.fit,  ~gender *  picture), infer = TRUE) 
#' 
#' ## Display only the within-level comparisons: 
#' displayPairs(arousal.allpairs, levels1 = c('female', 'male'), 
#'                                levels2 = c('infant', 'landscape', 'nude.f', 'nude.m'))
#'                                
#' @author Rachel Fewster
displayPairs = function(allpairs, levels1, levels2, brief = TRUE) {
  ## Ensure that allpairs is a data-frame with a column 'contrast':
  pairsdf = data.frame(allpairs)
  if (!("contrast" %in% names(pairsdf)))
    stop("pairsdf should have a column called 'contrast'. \n  Usage: pairsdf = pairs(emmeans(modelfit, ~fac1*fac2), infer=T))")

  if (brief)
    pairsdf$df = pairsdf$SE = pairsdf$t.ratio = NULL

  cat("Note: displayPairs is a s20x function that displays only the within-level comparisons from allpairs. \nTo see all comparisons, inspect the allpairs output itself.\n\n")
  ## Prepare the output list consisting of comparison texts for each factor level:
  outText = vector("list", length = length(levels1) + length(levels2))
  names(outText) = c(levels1, levels2)

  ## comboMat is a matrix with each row corresponding to one level of factor 1 and each column corresponding to one level of factor
  ## 2:
  comboMat = outer(levels1, levels2, FUN = "paste")
  dimnames(comboMat) = list(levels1, levels2)

  ## For comparisons within levels of factor 1 we want the combos of each row of comboMat with itself:
  for (lev in levels1) outText[[lev]] = as.vector(outer(comboMat[lev, ], comboMat[lev, ], FUN = "paste", sep = " - "))

  ## For comparisons within levels of factor 2 we want the combos of each column of comboMat with itself:
  for (lev in levels2) outText[[lev]] = as.vector(outer(comboMat[, lev], comboMat[, lev], FUN = "paste", sep = " - "))

  ## Return the output from pairsdf that matches each of the within-level factor comparisons:
  outList = lapply(outText, function(xtext) pairsdf[pairsdf$contrast %in% xtext, ])
  ## Replace any empty elements with an explanatory message:
  outList = lapply(outList, function(allpairs) if (nrow(allpairs) == 0)
    return("No contrasts for this level found in the allpairs object supplied") else return(allpairs))
  ## Print the output:
  return(print(outList, row.names = FALSE))
}
