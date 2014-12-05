clc;

clear all;

features_train = importdata('features.train'); %digit simmetry intensity
features_test = importdata('features.test'); %digit simmetry intensity

x_train = features_train(:,2:3);
y_train = features_train(:,1);

x_test = features_test(:,2:3);
y_test = features_test(:,1);

% 1 versus 5 Questions 5 and 6.

C = [0.0001; 0.001; 0.01; 0.1; 1];
Q = [2;5];

x_train_1_vs_5 = x_train(y_train == 1 | y_train == 5,:);

y_train_1_vs_5 = y_train(y_train == 1 | y_train == 5);
y_train_1_vs_5(y_train_1_vs_5 == 5) = -1;

x_test_1_vs_5 = x_test(y_test == 1 | y_test == 5,:);

y_test_1_vs_5 = y_test(y_test == 1 | y_test == 5);
y_test_1_vs_5(y_test_1_vs_5 == 5) = -1;

for i = 1 : size(Q)
    
    for j = 1 : size(C)

        q = Q(i);
        c = C(j);

        [ein, eout, model] = svm_polinomial_kernel(x_train_1_vs_5, y_train_1_vs_5, x_test_1_vs_5, y_test_1_vs_5, c, q);

        fprintf('1 versus 5 [C=%f, Q=%i]. Ein: %f, Eout: %f, Total SV Number: %i.\n ', c, q, ein, eout, model.totalSV);

    end
    
end

