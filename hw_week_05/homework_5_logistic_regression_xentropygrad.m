% Gradient of the cross-entropy error measure
function g = homework_5_logistic_regression_xentropygrad (Xn, yn, w)
  g = -(yn * Xn') / (1 + exp (yn * (w' * Xn')));
end