#' Two-way Analysis of Variance Summary
#'
#' Displays summary information for a two-way anova analysis. The lm object
#' must come from a numerical response variable and factors. The output depends
#' on the value of \code{page}:
#'
#' \itemize{
#' \item \code{page = "table"}: ANOVA table.
#' \item \code{page = "means"}: cell means matrix and numeric summary.
#' \item \code{page = "effects"}: table of effects.
#' \item \code{page = "interaction"}: interaction contrast tables.
#' \item \code{page = "nointeraction"}: main-effect contrast tables.
#' }
#'
#' @param fit an lm object, i.e. the output from \code{lm()}.
#' @param page options for output: \code{"table"}, \code{"means"},
#'     \code{"effects"}, \code{"interaction"}, or
#'     \code{"nointeraction"}.
#' @param digit the number of decimal places in the display.
#' @param conf.level confidence level of the intervals.
#' @param print.out if \code{TRUE}, print the output on the screen.
#' @param new if \code{TRUE} then this will run the new version of
#'     \code{summary2way} which should be more robust than the old
#'     version. However, it does not work in the same way. In
#'     particular, when \code{page = 'means'} it does not return
#'     summary statistics for each grouping of the data (pooled, by row
#'     factor, by column factor, and by interaction factor). Instead, it
#'     simply returns the means for each grouping.
#' @param all Only applicable to \code{page = "interaction"}. If
#'     \code{TRUE}, pairwise comparisons for all combinations of
#'     factor levels are shown. Otherwise, comparisons are only shown
#'     between combinations that have the same level for one of the
#'     factors.
#' @param FUN optional function to be applied to estimates and confidence intervals.
#'     Typically for backtransformation operations.
#' @param \dots other arguments such as \code{inttype} and \code{pooled}.
#' @return `summary2way()` prints the requested teaching summary page and
#'     invisibly returns the current summary components. The returned list has
#'     the following components: \item{Df}{degrees of
#'     freedom for regression, residual and total.} \item{Sum of
#'     Sq}{sum squares for regression, residual and total.} \item{Mean
#'     Sq}{mean squares for regression and residual.} \item{F
#'     value}{F-statistic value.} \item{Pr(F)}{The P-value associated
#'     with each F-test.} \item{Grand Mean}{The overall mean of the
#'     response variable.} \item{Row Effects}{The main effects for the
#'     first (row) factor.} \item{Col Effects}{The main effects for
#'     the second (column) factor.} \item{Interaction Effects}{The
#'     interaction effects if an interaction model has been fitted,
#'     otherwise \code{NULL}.}  \item{results}{If \code{new = TRUE},
#'     then this is a list with five components: \code{table} - the
#'     ANOVA table, \code{means} the table of means from
#'     \code{model.tables}, \code{effects} - the table of effects from
#'     \code{model.tables}, and \code{comparisons} - the differences
#'     in the means with standard errors, confidence bounds, and
#'     P-values from \code{TukeyHSD}}.
#' @seealso \code{\link{summary1way}}, \code{\link{model.tables}},
#'     \code{\link{TukeyHSD}}
#' @keywords models
#' @examples
#'
#' ## Arousal data:
#' data(arousal.df)
#' arousal.fit = lm(arousal ~ gender * picture, data = arousal.df)
#' summary2way(arousal.fit)
#' 
#' ## Butterfat data:
#' data("butterfat.df")
#' fit = lm(log(Butterfat) ~ Breed + Age, data = butterfat.df)
#' summary2way(fit, page = "nointeraction", FUN = exp)
#'
#' @export summary2way
summary2way = function(fit, page = c("table", "means", "effects", "interaction", "nointeraction"), 
                       digit = 5, conf.level = 0.95, print.out = TRUE, 
                       new = TRUE, all = FALSE, FUN = "identity", ...) {
  backtransform = if (is.character(FUN) && FUN == "identity") {
    FALSE
  } else {
    TRUE
  }
  page = match.arg(page)
  FUN = match.fun(FUN)
  
  if (!inherits(fit, "lm")) {
    stop("Input is not an \"lm\" object")
  }
  
  if (new) {
    
    ## We need some tests of whether this is a two-way model and whether interaction is present
    
    fitAov = aov(fit)
    
    responseIndex = attr(fitAov$terms, "response")
    numFactors = sum(attr(fitAov$terms, "dataClasses")[-responseIndex] == "factor")
    
    if (numFactors != 2) {
      stop("This is not a two-way ANOVA model")
    }
    
    ## test for interaction
    inter = if (any(attr(fitAov$terms, "order") == 2)) {
      TRUE
    } else {
      FALSE
    }
    
    resultsIdentity = list(table = anova(fitAov),
                            means = model.tables(fitAov, "means"),
                            effects = model.tables(fitAov, "effects"),
                            comparisons = TukeyHSD(fitAov, conf.level = conf.level))
    
    ## setup the ANOVA table so that it mimics the output from summary2way
    ## It isn't worth replicating the precision (digits) behaviour
    ## because this be done other ways
    attr(resultsIdentity$table, "heading") = "ANOVA Table:"
    names(resultsIdentity$table) = c("Df", "Sum Squares", "Mean Square", "F-statistic", "p-value")

    ## If FUN = identity, these will come out the same...
    results = resultsIdentity
    if (backtransform) {
      results$means$tables = lapply(resultsIdentity$means$tables, FUN)
      results$effects$tables = lapply(resultsIdentity$effects$tables, FUN)
      results$comparisons = lapply(resultsIdentity$comparisons,
                                   function(x) {
                                     cbind(FUN(x[, -4, drop = FALSE]), x[, 4, drop = FALSE])
                                   })
    }
    
    
    if (page == "table") {
      print(results$table) ## note this doesn't print the totals - do we care?
    } else if (page == "means"){
      cat("Table of means:\n")
      print(results$means$tables)
    } else if (page == "effects"){
      cat("Table of effects:\n")
      print(results$effects$tables)
    } else if (page == "nointeraction"){
      factorLabels = attr(fit$terms, "term.labels")[attr(fit$terms, "order") != 2]
      out = lapply(results$comparisons[factorLabels],
                    function(x) cbind(FUN(x[, 1:3, drop = FALSE]), x[, 4, drop = FALSE]))
      mostattributes(out) = attributes(results$comparisons)
      names(out) = factorLabels
      print(out)
    } else {# page == "interaction")
      if (!inter) {
        stop("No interaction term in model")
      }
      interactionLabel = attr(fit$terms, "term.labels")[attr(fit$terms, "order") == 2]
      out = results$comparisons[interactionLabel]
      if (all) {
          mostattributes(out) = attributes(results$comparisons)
          names(out) = interactionLabel
          print(out)
      } else {
          out = out[[1]]
          ## Extracting levels from each group being compared.
          groupNames = matrix(c(strsplit(rownames(out), "-", fixed = TRUE),
                                 recursive = TRUE), ncol = 2, byrow = TRUE)
          ## Getting level of first variable in the first group.
          group1Var1 = sapply(strsplit(groupNames[, 1], ":"), function(x) x[1])
          ## Getting level of first variable in the second group.
          group2Var1 = sapply(strsplit(groupNames[, 2], ":"), function(x) x[1])
          ## Getting level of second variable in the first group.
          group1Var2 = sapply(strsplit(groupNames[, 1], ":"), function(x) x[2])
          ## Getting level of second variable in the second group.
          group2Var2 = sapply(strsplit(groupNames[, 2], ":"), function(x) x[2])
          ## Matrix of 'within' comparisons.
          outWithin = out[group1Var1 == group2Var1, ]
          ## Matrix of 'between' comparisons.
          outBetween = out[group1Var2 == group2Var2, ]
          out = list(outWithin, outBetween)
          mostattributes(out) = attributes(results$comparisons)
          factor1 = strsplit(interactionLabel, ":")[1]
          names(out) = c(paste("Comparisons within", factor1),
                         paste("Comparisons between", factor1))
          print(out)
      }
    }
    
    invisible(list(Df = results$table$Df, 
                   `Sum of Sq` = results$table$`Sum Squares`, 
                   `Mean Sq` = results$table$`Mean Square`,
                   `F value` = results$table$`F-statistic`, 
                   `Pr(F)` = results$table$`p-value`, 
                   `Grand Mean` = results$means$tables[[1]], 
                   `Row Effects` = results$effects$tables[[1]], 
                   `Col Effects` = results$effects$tables[[2]], 
                   `Interaction Effects` = if (inter){
                     results$effects$tables[[3]]
                   } else {
                     NULL
                   },
                   results = results,
                   results.identity = resultsIdentity))
    
  } else {
    alist = anova(fit)
    
    if (nrow(alist) < 3 | nrow(alist) > 4) {
      stop("Not a Two-way ANOVA problem!")
    } else if (nrow(alist) == 3) {
      if (length(fit$contrast) != 2) {
        stop("All explanatory variables should be factors!")
      }
      
      inter = FALSE
      
    } else if (nrow(alist) == 4) {
      if (alist$Df[4] == 0) {
        stop("Need more than one observation per cell for interaction!")
      }
      
      if (length(fit$model) != 3) {
        stop("Not a Two-way ANOVA problem!")
      }
      
      if (length(fit$contrast) != 2) {
        stop("All explanatory variables should be factors!")
      }
      
      inter = TRUE
    }
    
    ## Another test to make sure all variables are factors because it seems that some models can slip through test above
    if (any(!sapply(fit$model[, -1], is.factor))) {
      stop("All explanatory variables should be factors!")
    }
    
    y = fit$model[, 1]
    f1 = factor(fit$model[, 2])
    f2 = factor(fit$model[, 3])
    f1F2 = as.factor(crossFactors(f1, f2))
    nlevF1 = length(unique(f1))
    nlevF2 = length(unique(f2))
    
    if (inter) {
      m = 3
    } else {
      m = 2
    }
    
    aDf = c(alist$Df, sum(alist$Df))
    aSs = round(c(alist$"Sum Sq", sum(alist$"Sum Sq")), digit)
    aMs = round(alist$"Mean Sq", digit)
    fvalue = round(alist$"F value"[1:m], digit)
    pvalue = round(alist$"Pr(>F)"[1:m], digit)
    aTable = cbind(aDf, aSs, c(paste(aMs), ""), c(paste(fvalue), "", ""), c(paste(pvalue), "", ""))
    
    if (inter) {
      dimnames(aTable) = list(c(row.names(alist), "Total        "), c("Df ", "Sum Squares ", "Mean Square ", "F-statistic ", "p-value   "))
    } else {
      dimnames(aTable) = list(c(row.names(alist), "Total    "), c("Df ", "Sum Squares ", "Mean Square ", "F-statistic ", "p-value   "))
    }
    
    group1 = split(y, f1)
    group2 = split(y, f2)
    n1 = length(group1)
    n2 = length(group2)
    
    if (inter) {
      f = factor(crossFactors(f1, f2))
      group3 = split(y, f)
      n3 = length(group3)
      group = c(group1, group2, group3)
    } else {
      group = c(group1, group2)
    }
    
    n = length(group)
    size = c(length(y), numeric(n))
    mea = c(mean(y), numeric(n))
    med = c(median(y), numeric(n))
    std = c(sd(y), numeric(n))
    mid = c(quantile(y, 0.75) - quantile(y, 0.25), numeric(n))
    
    for (i in 2:(n + 1)) {
      size[i] = length(group[[i - 1]])
      g = numeric(size[i])
      g = group[[i - 1]]
      mea[i] = mean(g)
      med[i] = median(g)
      std[i] = sd(g)
      mid[i] = quantile(g, 0.75) - quantile(g, 0.25)
    }
    size = round(size, digit)
    mea = round(mea, digit)
    med = round(med, digit)
    std = round(std, digit)
    mid = round(mid, digit)
    
    if (inter) {
      numericSummary = cbind(c(size[1], "", size[2:(n1 + 1)], "", size[(2 + n1):(n1 + n2 + 1)], "", size[(2 + n1 + n2):(n + 1)]), c(mea[1], "", mea[2:(n1 + 1)], "", mea[(2 + n1):(n1 + n2 + 1)], "", mea[(2 + 
                                                                                                                                                                                                              n1 + n2):(n + 1)]), c(med[1], "", med[2:(n1 + 1)], "", med[(2 + n1):(n1 + n2 + 1)], "", med[(2 + n1 + n2):(n + 1)]), c(std[1], "", std[2:(n1 + 1)], "", std[(2 + n1):(n1 + n2 + 1)], "", std[(2 + n1 + 
                                                                                                                                                                                                                                                                                                                                                                                                              n2):(n + 1)]), c(mid[1], "", mid[2:(n1 + 1)], "", mid[(2 + n1):(n1 + n2 + 1)], "", mid[(2 + n1 + n2):(n + 1)]))
      
      dimnames(numericSummary) = list(c("All Data  ", paste("By ", attributes(fit$terms)$variables[[3]], ":  "), paste(names(group1), "  "), paste("By ", attributes(fit$terms)$variables[[4]], ":  "), paste(names(group2), 
                                                                                                                                                                                                               "  "), "Combinations:  ", paste(names(group3), "  ")), c("Size  ", "Mean  ", "Median  ", "Std Dev  ", "Midspread  "))
    } else {
      numericSummary = cbind(c(size[1], "", size[2:(n1 + 1)], "", size[(2 + n1):(n1 + n2 + 1)]), c(mea[1], "", mea[2:(n1 + 1)], "", mea[(2 + n1):(n1 + n2 + 1)]), c(med[1], "", med[2:(n1 + 1)], "", med[(2 + 
                                                                                                                                                                                                             n1):(n1 + n2 + 1)]), c(std[1], "", std[2:(n1 + 1)], "", std[(2 + n1):(n1 + n2 + 1)]), c(mid[1], "", mid[2:(n1 + 1)], "", mid[(2 + n1):(n1 + n2 + 1)]))
      
      dimnames(numericSummary) = list(c("All Data  ", paste("By ", attributes(fit$terms)$variables[[3]], ":  "), paste(names(group1), "  "), paste("By ", attributes(fit$terms)$variables[[4]], ":  "), paste(names(group2), 
                                                                                                                                                                                                               "  ")), c("Size  ", "Mean  ", "Median  ", "Std Dev  ", "Midspread  "))
    }
    
    dc = dummy.coef(fit)
    
    if (!inter) {
      dc[[4]] = rep(0, n1 * n2)
    }
    
    effmat = (matrix(dc[[4]], n1, n2) + outer(dc[[2]], rep(1, n2)) + outer(rep(1, n1), dc[[3]])) + dc[[1]]
    modelMean = mean(effmat)
    cellMeans = matrix(NA, length(levels(f1)), length(levels(f2)))
    levf1 = levels(f1)
    levf2 = levels(f2)
    for (i in 1:length(levf1)) {
      for (j in 1:length(levf2)) {
        cellMeans[i, j] = mean(y[f1 == levf1[i] & f2 == levf2[j]])
      }
    }
    cellMeans = cbind(cellMeans, apply(effmat, 1, mean))
    cellMeans = rbind(cellMeans, c(apply(effmat, 2, mean), modelMean))
    dimnames(cellMeans) = list(c(rep(" ", length(levels(f1)) + 1)), c(rep(" ", length(levels(f2)) + 1)))
    matr = rbind(rep("", ncol(effmat)))
    matr[1, as.integer((length(levels(f2)) + 1)/2)] = as.character(attributes(fit$terms)$variables[[4]])
    matr = c("", "", matr, "")
    matc = cbind(rep("", nrow(effmat)))
    matc[as.integer((length(levels(f1)) + 1)/2), 1] = as.character(attributes(fit$terms)$variables[[3]])
    matc = c(matc, "")
    C = c(levels(f1), as.character(attributes(fit$terms)$variables[[4]]))
    R = c("", "", levels(f2), as.character(attributes(fit$terms)$variables[[3]]))
    M1 = cbind(matc, C, format(round(cellMeans, digit), digit = 5))
    M2 = rbind(matr, R, M1)
    rowEffect = apply(effmat, 1, mean) - mean(apply(effmat, 1, mean))
    colEffect = apply(effmat, 2, mean) - mean(apply(effmat, 2, mean))
    interact = (effmat - outer(apply(effmat, 1, mean), rep(1, n2)) - outer(rep(1, n1), apply(effmat, 2, mean))) + mean(effmat)
    effmat1 = cbind(interact, rowEffect)
    effmat2 = rbind(effmat1, c(colEffect, modelMean))
    dimnames(effmat2) = list(c(rep(" ", length(levels(f1)) + 1)), c(rep(" ", length(levels(f2)) + 1)))
    matr = rbind(rep("", ncol(effmat)))
    matr[1, as.integer((length(levels(f2)) + 1)/2)] = as.character(attributes(fit$terms)$variables[[4]])
    matr = c("", "", matr, "")
    matc = cbind(rep("", nrow(effmat)))
    matc[as.integer((length(levels(f1)) + 1)/2), 1] = as.character(attributes(fit$terms)$variables[[3]])
    matc = c(matc, "")
    C = c(levels(f1), paste(as.character(attributes(fit$terms)$variables[[4]]), "effect"))
    R = c("", "", levels(f2), paste(as.character(attributes(fit$terms)$variables[[3]]), "effect"))
    M3 = cbind(matc, C, format(round(effmat2, digit), digit = 5))
    M4 = rbind(matr, R, M3)
    f1Name = row.names(alist)[1]
    f2Name = row.names(alist)[2]
    
    comparisons = NULL
    
    if (page == "table") {
      cat("ANOVA Table:\n")
      print(aTable, quote = FALSE)
    } else if (page == "means") {
      cat("\n\nCell-means Matrix:\n")
      print(M2, quote = FALSE)
      cat("\nNumeric Summary:\n")
      print(numericSummary, quote = FALSE)
    } else if (page == "effects") {
      cat("\n\nTable of Effects:\n")
      print(M4, quote = FALSE)
    } else if (page == "interaction") {
      cat(paste("\n\nComparisons within ", f1Name, ":\n\n", sep = ""))
      contrastMatrix1 = names = NULL
      offset = 1
      for (levs in 1:nlevF1) {
        temp = matrix(0, nrow = (nlevF2 * (nlevF2 - 1)/2), ncol = nlevF1 * nlevF2)
        row = 1
        for (i in offset:(levs * nlevF2 - 1)) {
          for (j in (i + 1):(levs * nlevF2)) {
            temp[row, i] = 1
            temp[row, j] = -1
            names = c(names, paste(levels(f1F2)[i], " - ", levels(f1F2)[j]))
            row = row + 1
          }
        }
        contrastMatrix1 = as.matrix(rbind(contrastMatrix1, temp))
        offset = offset + nlevF2
      }
      row.names(contrastMatrix1) = names
      fit1Way = lm(y ~ f1F2)
      L = (nlevF1 * nlevF2/2) * (1 + nlevF1)
      contrasts1 = estimateContrasts(as.matrix(contrastMatrix1), fit1Way, alpha = 1 - conf.level, row = TRUE, L, FUN = FUN)
      print(contrasts1, quote = FALSE)
      comparisons$within = contrasts1
      
      cat(paste("\n\nComparisons between ", f1Name, ":\n\n", sep = ""))
      contrastMatrix2 = names = NULL
      temp = matrix(0, nrow = nlevF2, ncol = nlevF1 * nlevF2)
      nrows = nlevF1 * (nlevF1 - 1)/2
      for (i in seq(1, nlevF1 * nlevF2 - nlevF2, nlevF2)) {
        for (j in seq(i + nlevF2, nlevF1 * nlevF2, nlevF2)) {
          for (row in 1:nlevF2) {
            temp[row, i + row - 1] = 1
            temp[row, j + row - 1] = -1
            names = c(names, paste(levels(f1F2)[i + row - 1], " - ", levels(f1F2)[j + row - 1]))
          }
          contrastMatrix2 = as.matrix(rbind(contrastMatrix2, temp))
          temp = matrix(0, nrow = nlevF2, ncol = nlevF1 * nlevF2)
        }
      }
      row.names(contrastMatrix2) = names
      contrasts2 = estimateContrasts(as.matrix(contrastMatrix2), fit1Way, alpha = 1 - conf.level, row = TRUE, L, FUN = FUN)
      print(contrasts2, quote = FALSE)
      comparisons$between = contrasts2
      
    } else if (page == "nointeraction") {
      cat(paste("\n\n", f1Name, " comparisons:\n\n", sep = ""))
      contrastMatrix1 = matrix(0, nrow = nlevF1 * (nlevF1 - 1)/2, ncol = nlevF1)
      row = 1
      names = NULL
      for (i in 1:(nlevF1 - 1)) {
        for (j in (i + 1):nlevF1) {
          contrastMatrix1[row, i] = 1
          contrastMatrix1[row, j] = -1
          names = c(names, paste(levels(f1)[i], " - ", levels(f1)[j]))
          row = row + 1
        }
      }
      
      row.names(contrastMatrix1) = names
      contrastMatrix1 = as.matrix(contrastMatrix1)
      contrasts1 = estimateContrasts(contrastMatrix1, fit, alpha = 1 - conf.level, row = TRUE, FUN = FUN)
      print(contrasts1, quote = FALSE)
      eval(parse(text = paste0("comparisons$", f1Name, "= contrasts1")))
      
      cat(paste("\n\n", f2Name, " comparisons:\n\n", sep = ""))
      contrastMatrix2 = matrix(0, nrow = nlevF2 * (nlevF2 - 1)/2, ncol = nlevF2)
      row = 1
      names = NULL
      for (i in 1:(nlevF2 - 1)) {
        for (j in (i + 1):nlevF2) {
          contrastMatrix2[row, i] = 1
          contrastMatrix2[row, j] = -1
          names = c(names, paste(levels(f2)[i], " - ", levels(f2)[j]))
          row = row + 1
        }
      }
      
      row.names(contrastMatrix2) = names
      contrastMatrix2 = as.matrix(contrastMatrix2)
      contrasts2 = estimateContrasts(contrastMatrix2, fit, alpha = 1 - conf.level, row = FALSE, FUN = FUN)
      
      
      print(contrasts2, quote = FALSE)
      eval(parse(text = paste0("comparisons$", f2Name, "= contrasts2")))
    }
    
    if (!inter) {
      interact = NULL
    }
    
    invisible(list(Df = aDf, `Sum of Sq` = aSs, `Mean Sq` = aMs, `F value` = alist$"F value"[1:m], `Pr(F)` = alist$"Pr(>F)"[1:m], `Grand Mean` = modelMean, `Row Effects` = rowEffect, `Col Effects` = colEffect, `Interaction Effects` = interact, 
                   Comparisons = comparisons))
  }
}

