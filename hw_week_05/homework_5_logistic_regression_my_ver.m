% !!! NOT WORKING !!!

clc;

s = RandStream('mt19937ar','Seed',1);
RandStream.setGlobalStream(s);

% Input space dimension
d = 2 ;
% Data set size
N = 100;
% Test point size
Ntest = 100;
% number fo runs to compute Eout
runs = 1;
% termination condition
term = 0.01;
% learning rate
eta = 0.01;

Eout = zeros(1, runs);

myrundata = [];

for r = 1:runs
    
    currentStream=RandStream.getGlobalStream();
    
    % N random examples with the synthetic dimension x0
    X = [ones(N, 1) unifrnd(-1, 1, N, d)];    
    
    % Target function weights
    wt = unifrnd(-1, 1, size(X, 2), 1);
    
    % Uses the target function to set the desired labels
    y = sign(X * wt);
    
    w = zeros(d + 1, 1);
   
    epoch = 0;
    
    MYW = [];
    
    while 1
        
        epoch = epoch + 1;
        
        perm = randperm(N);
        
        w_previous = w;
        
        MYW(epoch,:) = w;
        
        for t = 1:N
            
            Xn = X(perm(t),:);
            yn = y(perm(t));
                         
            w = w - eta * (-(yn * Xn') / (1 + exp (yn * (w' * Xn'))));
                        
        end        
        
        if norm(w_previous - w) < term
            break;
        end
         
    end
    
    Xtest = [ones(Ntest, 1) unifrnd(-1, 1, Ntest, d)];
    ytest = sign(Xtest * wt);
        
    func = @(n) log (1 + exp (-ytest(n) * (w' * Xtest(n,:)')));
    eout = mean(arrayfun(func, 1:Ntest));
    myrundata(r,:) = [eout, epoch]; %#ok<*SAGROW>
        
end

fprintf('Eout: %.3f , Avg Epoch: %.3f\n', mean (myrundata, 1));


