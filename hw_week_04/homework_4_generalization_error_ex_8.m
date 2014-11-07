% For each q >= 1
for q = 1:10

  % Growth function with q fixed
  gf = @ (N) homework_4_generalization_error_ex_8_mhq8 (N, q);

  % Finds the VC dimension for the growth function gf
  dvc = homework_4_generalization_error_ex_8_mhvc (gf);

  % If the ith N is the breakpoint, then the (i-1)th point must be the dvc
  fprintf ('dvc=%d for q=%d\n', dvc, q);
  
end