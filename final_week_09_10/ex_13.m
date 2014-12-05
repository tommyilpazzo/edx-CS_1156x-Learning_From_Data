addpath('libsvm-3.20/windows');

total_runs = 1000;

fprintf('13)\n');

linearly_inseparables = 0;

h = waitbar(0, 'Running RBF-SVM, checking for separability...');

n = 100;

for i = 1 : total_runs
    
    X = unifrnd(-1,1, n, 2);
    y = sign(X(:, 2) - X(:, 1) + sin(pi * X(:, 1)) / 4);
  
    libsvm_options = char(strcat(...
        {'-s 0 '},... % svm_type
        {'-t 2 '},... % kernel_type : set type of kernel function
        {'-g '}, {'1.5'}, {' '},... % gamma : set gamma in kernel
        {'-c '}, {'10e10'}, {' '},... % cost : set the parameter C of C-SVC, epsilon-SVR, and nu-SVR
        {'-h 0 '},... % shrinking : whether to use the shrinking heuristics, 0 or 1
        {'-q '}... % quiet mode (no outputs)
    ));
    
    model = svmtrain(y, X, libsvm_options);
    
    [predicted_label] = svmpredict(y, X, model, '-q');

    ein = mean (sign(predicted_label) ~= y);
    
    failed = ein ~= 0;
    
    linearly_inseparables = linearly_inseparables + failed;
    
    waitbar(i / total_runs, h);
    
end

fprintf('\nPercentage of inseparables: %.1f\n', (linearly_inseparables / total_runs) * n);
