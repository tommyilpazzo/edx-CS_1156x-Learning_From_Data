1;

% Target function
target = @ (x) sin (pi * x);

% Feature transformation (no-op)
transform = @ (X) X;

% Hypothesis function
hypothesis = @ (X, y) homework_4_generalization_error_ex_4_5_6_linearreg (X, y);

% Number of iterations
iter = 10000;

% Input distribution
spc = [-1 1];

% Number of points on each sample
nsample = 2;

% Number of examples overall
N = 10000;

% Calculates the decomposed out of sample error
[gbar, bias, var] = homework_4_generalization_error_ex_4_5_6_deceout (N, spc, nsample, target, transform, hypothesis, iter);

fprintf ('gbar(x)  = %f\n', gbar);
fprintf ('bias     = %f\n', bias);
fprintf ('variance = %f\n', var);

fprintf ('Eout = %f\n', bias + var);