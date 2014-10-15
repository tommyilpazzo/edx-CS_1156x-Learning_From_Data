clc;

% define number of runs
r = 1000;

% define number of points in data set
N = 1000;

Nout = 1000;

doplot = 0;

sum_Ein = 0;
num_Ein = r;

sum_Eout = 0;
num_Eout = r;

while r > 0
    
    % define data set
    X = (rand(N,2)*2)-1;        
    % evaluate target function on each x_n
    Y = sign(X(:,1).^2 + X(:,2).^2 - 0.6);
    % replace zero (0) with one (1)
    Y(Y==0)=1;
    % define features vector
    X = [ones(N,1) X(:,1) X(:,2) (X(:,1).*X(:,2)) (X(:,1).^2) (X(:,2).^2)];
            
    %flip the sign of the ourput in a random 10% subset
    noisy_indices = randperm(N, round(N/10));
    Y(noisy_indices) = -Y(noisy_indices);
    
    % calculate weights using linear regression algorithm
    w = pinv(X) * Y;
     
    h = sign(sum(X * w,2));

    % replace zero (0) with one (1)
    h(h==0)=1;
            
    Ein = (sum(abs(Y - h))/2) / N;
        
    sum_Ein = sum_Ein + Ein;
    
    % define out of sample points
    Xout = (rand(N,2)*2)-1;
    % evaluate target function on each xout_n
    Yout = sign(Xout(:,1).^2 + Xout(:,2).^2 - 0.6);
    % replace zero (0) with one (1)
    Yout(Yout==0)=1;
    %flip the sign of the ourput in a random 10% subset
    noisy_indices = randperm(Nout, round(Nout/10));
    Yout(noisy_indices) = -Yout(noisy_indices);
    % define features vector
    Xout = [ones(N,1) Xout(:,1) Xout(:,2) (Xout(:,1).*Xout(:,2)) (Xout(:,1).^2) (Xout(:,2).^2)];
         
    hout = sign(sum(Xout * w,2));

    % replace zero (0) with one (1)
    hout(hout==0)=1;
    
    Eout = (sum(abs(Yout - hout))/2) / Nout;
    
    sum_Eout = sum_Eout + Eout;
       
    % decrement runs counter
    r = r - 1;
    
end

avg_Ein = sum_Ein / num_Ein;

fprintf('Average Ein(g): '); 
fprintf('%f: \n', avg_Ein);

avg_Eout = sum_Eout / num_Eout;

fprintf('Average Eout(g): '); 
fprintf('%f: \n', avg_Eout);









