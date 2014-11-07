% Growth function for question #8
function n = homework_4_generalization_error_ex_8_mhq8(N, q)
  if N == 1
     n = 2;
  else
    if q > N-1
      x = 0;
    else
      x = nchoosek (N-1, q);
    end

    n = 2 * homework_4_generalization_error_ex_8_mhq8 (N-1, q) - x;
  end
end