clc;

% Input distribution
spc = [-1 1];

% Number of training examples. Change this according to the question
N = 10;

% Number of dimensions
d = 2;

% Hard-margin SVM
C = Inf;

% Number of times the experiment will be computed
runs = 1000;

% Linear kernel
kernel_function = @ (x, xp) x * xp';

for r = 1:runs
   
    while true

        % N random examples and introduces the synthetic dimension x0
        X = [ones(N, 1) unifrnd(spc(1), spc(2), N, d)];

        % Weight vector that represents the target function f
        wf = unifrnd (spc(1), spc(2), size (X, 2), 1);

        % Uses the target function to set the desired labels
        y = sign (X * wf);

        pos = find (y > 0);
        neg = find (y < 0);

        % Make sure we have both positive and negative examples
        if (any (pos) && any (neg))
          break;
        end
    end
    
    % Compute PLA
    
    % Initial weights
	w = zeros (d+1, 1);
    
    cnt = 0;
    nw = w;

    while cnt < 1000
        
        m = find (bsxfun (@ (n, y) sign (X(n,:) * nw) ~= y, (1:size(X))', y));

        % Tests algorithm convergence
        if not(any(m))
            break;
        end

        % Randomly picks the index of a misclassified item
        sm = size (m, 1);
        n = fix (unifrnd (1, sm));

        if (isnan (n))
            n = 1;
        end

        % Updates the weight vector accordingly
        nw = nw + X(m(n),:)' * y(m(n),1);

        % Only increments the counter if there's change
        cnt = cnt + 1;
        
    end
    
    wpla = nw;
    
    % Compute SVM
    
    % Removes the x0, which is not needed for SVM
    X = X(:, 2:size (X, 2));
    
    %[wsvm, sv] = svm (X, y, k, C, 100);
    
    %Maximum nuber of iters
    maxIters = 100;
    
    % Number of examples
    N = length (X);
    
    % Linear coefficient
    f = -ones(N, 1);
    
    % Subject to
    Aeq = y';
    beq = 0;
    
    % Lower and upper bounds
    lb = zeros (N, 1);
    ub = ones (N, 1) * C;
    
    % Other options
    options = optimoptions('quadprog','Algorithm','interior-point-convex','Display','off','MaxIter', maxIters);
    
    % Quadratic coefficients
    H = [];

    for i = 1:N
        for j = 1:N
            H(i,j) = y(i) * y(j) * kernel_function (X(i,:), X(j,:)); %#ok<*SAGROW>
        end
    end
            
    % Solves the quadratic programming to get the final alphas
    alpha = quadprog(H, f, [], [], Aeq, beq, lb, [], [], options);
    
    % Finds the support vectors
    sv = find(alpha > 1e-7);

    % Returns weight vector w from x
    w = [sum(alpha(sv) .* y(sv) .* X(sv, 1)); sum(alpha(sv) .* y(sv) .* X(sv, 2))];

    % Returns the b value using the first support vector found
    b = y(sv(1)) - sum (alpha(sv) .* y(sv) .* kernel_function (X(sv, :), X(sv(1), :)));

    % B is the x0
    w = [b; w]; %#ok<AGROW>
    
    wsvm = w;
    
    % Compare methods
    
    % Loops until we find negative and positive examples
    while true
        
        % N random examples and introduces the synthetic dimension x0
        Xtest = ones((runs*5), d+1);
        Xtest(:,2:d+1) = unifrnd(spc(1), spc(2), (runs*5), d);

        % Target labels
        ytest = sign (Xtest * wf);

        pos = find (ytest > 0);
        neg = find (ytest < 0);

        % Make sure we have both positive and negative examples
        if (any (pos) && any (neg))
          break;
        end
        
    end

    % Calculates Eout for both w1 and w2
    eout1 = mean (sign (Xtest * wsvm) ~= ytest);
    eout2 =mean (sign (Xtest * wpla) ~= ytest);

    % Returns whether w1 has better Eout than w2
    w1better = (eout1 - eout2) < 0;
    
    rundata(r,1) = w1better;
    rundata(r,2) = length (sv);
       
end

fprintf ('SVM is better than PLA %.2f%% of the time\n', ...
            mean(rundata(:,1)) * 100);

fprintf ('Average number of support vectors: %.2f\n', ...
            mean (rundata(:,2)));