clc;

clear all;

features_train = importdata('features.train'); %digit simmetry intensity
features_test = importdata('features.test'); %digit simmetry intensity

x_train = features_train(:,2:3);
y_train = features_train(:,1);

x_test = features_test(:,2:3);
y_test = features_test(:,1);

% One versus all. Questions 2, 3 and 4.

C = 0.01;
Q = 2; 

digits = unique(y_train);

for i = 1 : size(digits)
    
    for j = 1 : size(C)
        
        d = digits(i);
        c = C(j);
        
        y_train_one_vs_all = -ones(size(y_train,1),1);
        y_train_one_vs_all(y_train == d) = 1;    
        
        y_test_one_vs_all = -ones(size(y_test,1),1);
        y_test_one_vs_all(y_test == d) = 1;
        
        [ein, eout, model] = svm_polinomial_kernel(x_train, y_train_one_vs_all, x_test, y_test_one_vs_all, c, Q);
        
        fprintf('%i versus all [C=%f, Q=%i]. Ein: %f, Eout: %f, Total SV Number: %i.\n ', d, c, Q, ein, eout, model.totalSV);
    
    end
    
end


