% Devroye bound
function epsilon = homework_4_generalization_error_ex_2_devroye (N, dvc, delta)

    epsilon = 1;

    not_done = 1;

    while not_done
      
        oldepsilon = epsilon;

        scale = 1/(2*N);
        implicit = (4*epsilon * (1+epsilon));

        if N <= dvc
          epsilon = sqrt ( scale * (implicit + log ((4 * 4^N) / delta)));
        else
          % Here, we changed the inequality a little bit to make it more stable
          % for larger Ns
          epsilon = sqrt ( scale * (implicit + ((2*dvc * log (N) - ...
                                                 log (delta) + log (4)))));
        end

        if (abs (oldepsilon - epsilon) < 0.001)
            not_done = 0;
        end
        
    end
  
end