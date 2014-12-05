function [ein, eout, model] = svm_rbf_kernel(x_train, y_train, x_test, y_test, gamma, c)

    addpath('libsvm-3.20/windows');

    % model = svmtrain(training_label_vector, training_instance_matrix, 'libsvm_options')
    % polynomial kernel: (gamma*u'*v + coef0)^degree

    libsvm_options = char(strcat(...
        {'-s 0 '},... % svm_type
        {'-t 2 '},... % kernel_type : set type of kernel function
        {'-g '}, {num2str(gamma)}, {' '},... % gamma : set gamma in kernel
        {'-c '}, {num2str(c)}, {' '},... % cost : set the parameter C of C-SVC, epsilon-SVR, and nu-SVR
        {'-h 0 '},... % shrinking : whether to use the shrinking heuristics, 0 or 1
        {'-q '}... % quiet mode (no outputs)
    ));

    model = svmtrain(y_train, x_train, libsvm_options);

    % [predicted_label] = svmpredict(testing_label_vector, testing_instance_matrix, model, 'libsvm_options')
    [predicted_label] = svmpredict(y_train, x_train, model, '-q');

    ein = mean (sign(predicted_label) ~= y_train);

    [predicted_label] = svmpredict(y_test, x_test, model, '-q');

    eout = mean (sign(predicted_label) ~= y_test);
       
end

