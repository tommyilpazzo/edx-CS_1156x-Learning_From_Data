% Rademacher penalty bound
function epsilon = homework_4_generalization_error_ex_2_rademacher (N, dvc, delta)
  epsilon = sqrt ((2 * log (2 * N * homework_4_generalization_error_ex_2_mh (N, dvc))) / N) + ...
            sqrt ((2/N) * log (1/delta)) + (1/N);
end