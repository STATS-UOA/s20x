summaryStats<-function(x, ...){
  UseMethod("summaryStats")
}

summaryStats.default<-function(x, group = rep("Data", length(x)), data.order = TRUE, digits = 2, ...){
  if (!is.factor(group))
    group = factor(group, levels = if (data.order)
      unique(group) else sort(unique(group)))

  if(length(unique(group))==1){
    qtls<-round(quantile(x,c(0.25,0.5,0.75)),digits)
    cat(paste("Minimum value:          ",round(min(x),digits),"\n"))
    cat(paste("Maximum value:          ",round(max(x),digits),"\n"))
    cat(paste("Mean value:             ",round(mean(x),digits),"\n"))
    cat(paste("Median:                 ",qtls[2],"\n"))
    cat(paste("Upper quartile:         ",qtls[3],"\n"))
    cat(paste("Lower quartile:         ",qtls[1],"\n"))
    cat(paste("Variance:               ",round(var(x),digits),"\n"))
    cat(paste("Standard deviation:     ",round(sd(x),digits),"\n"))
    cat(paste("Midspread (IQR):        ",round(IQR(x),digits),"\n"))
    cat(paste("Skewness:               ",round(skewness(x),digits),"\n"))
    cat(paste("Number of data values:  ",length(x),"\n"))
  }else{
    do.call("rbind",
            tapply(x, group,
                   function(x) c("Sample size" = length(x),
                                 "Mean" = mean(x),
                                 "Median" = median(x),
                                 "Std Dev" = sd(x),
                                 "Midspread" = IQR(x))))
  }
}

summaryStats.formula<-function(x, data = NULL, data.order = TRUE, digits = 2, ...){
  if (missing(x) || (length(x) != 3))
    stop("missing or incorrect formula")
  if (is.null (data) ) vars = eval(attr(terms(x), "variables"), parent.frame())
  else vars <- eval (attr (terms (x), "variables"), data)
  summaryStats(vars[[1]], vars[[2]], data.order = data.order, digits = digits)
}

