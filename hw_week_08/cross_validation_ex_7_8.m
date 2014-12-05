clc;

clear all;

features_train = importdata('features.train'); %digit simmetry intensity
features_test = importdata('features.test'); %digit simmetry intensity

X = features_train(:,2:3);
y = features_train(:,1);

% 1 versus 5 Questions 7.

C = [0.0001; 0.001; 0.01; 0.1; 1];
Q = 2;

X = X(y == 1 | y == 5,:);

y = y(y == 1 | y == 5);
y(y == 5) = -1;
   
runs = 100;

fold_number = 10;

fold_size = floor(round(size(X,1) / fold_number));

X = X(1:(fold_number*fold_size),:);
y = y(1:(fold_number*fold_size));

F = zeros(fold_number, fold_size);

for f = 0 : fold_number -1
   
    F(f+1,:) = (f*fold_size)+1 : (f+1)*fold_size;
    
end

S = zeros(size(C,1),1); % Selections

Ecv = zeros(runs,size(C,1));

for r = 1 : runs
    
    idx = randperm(size(X,1));
        
    Xperm = X(idx,:);
    yperm = y(idx);
    
    for j = 1 : size(C,1)

        c = C(j);
        
        Eout = zeros(fold_number,1);
                
        for f = 1 : fold_number
        
            Xtrain = Xperm;
            ytrain = yperm;
            
            Xtrain(F(f,:),:) = [];
            ytrain(F(f,:)) = [];

            Xtest = Xperm(F(f,:),:);
            ytest = yperm(F(f,:));

            [ein, eout, model] = svm_polinomial_kernel(Xtrain, ytrain, Xtest, ytest, c, Q);
            
            Eout(f) = eout;
        
        end
        
        Ecv(r,j) = mean(Eout);
        
    end
    
    [ecv, i] = min(Ecv(r,:));
    
    S(i) = S(i) + 1;
           
end

for j = 1 : size(C)
    
    fprintf('1 versus 5 [C=%f, Q=%i]. Average Ecv: %f , Number of selections: %i (%i runs).\n ', C(j), Q, mean(Ecv(:,j)), S(j), runs);
    
end

