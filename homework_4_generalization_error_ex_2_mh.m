% Growth function based on N and VC dimension
function k = homework_4_generalization_error_ex_2_mh (N, dvc)
  if N <= dvc
    k = 2^N;
  else
    k = N^dvc;
  end
end