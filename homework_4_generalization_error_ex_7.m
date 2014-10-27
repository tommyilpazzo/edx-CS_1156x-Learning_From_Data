1;

% Target function
target = @ (x) sin (pi * x);

% Hypothesis function
hypothesis = @ (X, y) homework_4_generalization_error_ex_4_5_6_linearreg (X, y);

% Number of iterations
iter = 10^4;

% Input distribution
spc = [-1 1];

% Number of points on each sample
nsample = 2;

% Number of examples overall
N = 10^2;

% Calculates Eout based on the bias/variance decomposition for each hypothesis set

% Constant
transform = @ (X) ones (N, 1);
[~, bias, var] = homework_4_generalization_error_ex_4_5_6_deceout (N, spc, nsample, target, transform, hypothesis, iter);
fprintf ('Eout h(x) = b is %.2f [bias=%.2f, var=%.2f]\n', ...
        bias + var, bias, var);

% Line that passes through origin (0, 0)
transform = @ (X) X;
[~, bias, var] = homework_4_generalization_error_ex_4_5_6_deceout(N, spc, nsample, target, transform, hypothesis, iter);
fprintf ('Eout h(x) = ax is %.2f [bias=%.2f, var=%.2f]\n', ...
        bias + var, bias, var);

% Line with intercept
transform = @ (X) [ones(N, 1) X];
[~, bias, var] = homework_4_generalization_error_ex_4_5_6_deceout(N, spc, nsample, target, transform, hypothesis, iter);
fprintf ('Eout h(x) = ax+b is %.2f [bias=%.2f, var=%.2f]\n', ...
        bias + var, bias, var);

% Curve that passes through origin (0, 0)
transform = @ (X) X.^2;
[~, bias, var] = homework_4_generalization_error_ex_4_5_6_deceout(N, spc, nsample, target, transform, hypothesis, iter);
fprintf ('Eout h(x) = ax^2 is %.2f [bias=%.2f, var=%.2f]\n', ...
        bias + var, bias, var);

% Curve with intercept
transform = @ (X) [ones(N, 1), X.^2];
[~, bias, var] = homework_4_generalization_error_ex_4_5_6_deceout(N, spc, nsample, target, transform, hypothesis, iter);
fprintf ('Eout h(x) = ax^2+b is %.2f [bias=%.2f, var=%.2f]\n', ...
        bias + var, bias, var);