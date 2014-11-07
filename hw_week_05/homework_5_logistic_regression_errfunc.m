% Surface that represents the error function
function nw = homework_5_logistic_regression_errfunc (w)
  nw = (w(1) * exp (w(2)) - 2*w(2) * exp (-w(1)))^2;
end