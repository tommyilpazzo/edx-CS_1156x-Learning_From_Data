clc;

clear all;

features_train = importdata('features.train'); %digit simmetry intensity
features_test = importdata('features.test'); %digit simmetry intensity

x_train = features_train(:,2:3);
y_train = features_train(:,1);

x_test = features_test(:,2:3);
y_test = features_test(:,1);

C = [0.01; 1; 100; 1e4; 1e6];

gamma = 1;

x_train_1_vs_5 = x_train(y_train == 1 | y_train == 5,:);

y_train_1_vs_5 = y_train(y_train == 1 | y_train == 5);
y_train_1_vs_5(y_train_1_vs_5 == 5) = -1;

x_test_1_vs_5 = x_test(y_test == 1 | y_test == 5,:);

y_test_1_vs_5 = y_test(y_test == 1 | y_test == 5);
y_test_1_vs_5(y_test_1_vs_5 == 5) = -1;

for i = 1 : size(C,1)
   
    c = C(i);
        
    [ein, eout, model] = svm_rbf_kernel(x_train_1_vs_5, y_train_1_vs_5, x_test_1_vs_5, y_test_1_vs_5, gamma, c);
 
    fprintf('1 versus 5 [C=%f, Gamma=%i]. Ein: %f, Eout: %f, Total SV Number: %i.\n ', c, gamma, ein, eout, model.totalSV);
    
end

% x_train_4_vs_6 = x_train(y_train == 4 | y_train == 6,:);
% 
% y_train_4_vs_6 = y_train(y_train == 4 | y_train == 6);
% y_train_4_vs_6(y_train_4_vs_6 == 4) = 1;
% y_train_4_vs_6(y_train_4_vs_6 == 6) = -1;
% 
% x_test_4_vs_6 = x_test(y_test == 4 | y_test == 6,:);
% 
% y_test_4_vs_6 = y_test(y_test == 4 | y_test == 6);
% y_test_4_vs_6(y_test_4_vs_6 == 4) = 1;
% y_test_4_vs_6(y_test_4_vs_6 == 6) = -1;
% 
% for i = 1 : size(C,1)
%    
%     c = C(i);
%         
%     [ein, eout, model] = svm_rbf_kernel(x_train_4_vs_6, y_train_4_vs_6, x_test_4_vs_6, y_test_4_vs_6, gamma, c);
%  
%     fprintf('4 versus 6 [C=%f, Gamma=%i]. Ein: %f, Eout: %f, Total SV Number: %i.\n ', c, gamma, ein, eout, model.totalSV);
%     
% end