predictLmWithSe = function(object, newdata, ...) {
  predict.lm(object, newdata, se.fit = TRUE, ...)
}

predictGlmWithSe = function(object, newdata, ...) {
  predict.glm(object, newdata, se.fit = TRUE, ...)
}
