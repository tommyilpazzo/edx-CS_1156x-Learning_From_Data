% Returns the dvc given the growth function gf
function dvc = homework_4_generalization_error_ex_8_mhvc (gf)
  
    dvc = 0;

    % Number of examples
    N = 0;

    while 1 
        N = N + 1;

        if gf (N) < 2^N 
            dvc = N-1;
            break;
        end
    end
end