% Calculates the linear regression
function w = homework_4_generalization_error_ex_4_5_6_linearreg (X, y)
  w = pinv (X) * y;
end