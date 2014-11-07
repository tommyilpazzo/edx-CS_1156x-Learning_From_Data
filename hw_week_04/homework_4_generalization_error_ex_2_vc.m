% Original VC bound
function epsilon = homework_4_generalization_error_ex_2_vc (N, dvc, delta)
  epsilon = sqrt ((8/N) * log ((4 * ...
      homework_4_generalization_error_ex_2_mh (N, dvc)) / delta));
end