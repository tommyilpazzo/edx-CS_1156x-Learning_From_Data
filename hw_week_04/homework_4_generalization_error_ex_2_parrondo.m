% Parrondo and Van den Broek bound
function epsilon = homework_4_generalization_error_ex_2_parrondo (N, dvc, delta)
    
    epsilon = homework_4_generalization_error_ex_2_vc (N, dvc, delta);

    not_done = 1;

    while not_done

        oldepsilon = epsilon;
        epsilon = sqrt ((1/N) * (2*epsilon + log ((6 * homework_4_generalization_error_ex_2_mh (2*N, dvc)) / delta)));
        
        if (abs (oldepsilon - epsilon) < 0.001)
            not_done = 0;
        end
    
    end
    
end