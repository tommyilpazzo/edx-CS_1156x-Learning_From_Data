clc;

sigma = 0.1;
d = 8;
N = [10;25;100;500;1000];

for i = 1:size(N)

    ein = homework_5_linear_regression_error_ein(sigma, d, N(i));
    
    fprintf('N = %i, Ein = %f\n', N(i), ein); 

end
