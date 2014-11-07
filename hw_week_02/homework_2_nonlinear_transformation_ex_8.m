clc;

% define number of runs
r = 1000;

% define number of points in data set
N = 1000;

doplot = 0;

sum_Ein = 0;
num_Ein = r;

while r > 0
    
    % define data set
    x = [ones(N,1) (rand(N,2)*2)-1];
        
    % evaluate target function on each x_n
    y = sign(x(:,2).^2 + x(:,3).^2 - 0.6);
    % replace zero (0) with one (1)
    y(y==0)=1;
            
    %flip the sign of the ourput in a random 10% subset
    noisy_indices = randperm(N, round(N/10));
    y(noisy_indices) = -y(noisy_indices);
    
    % calculate weights using linear regression algorithm
    w = pinv(x) * y;
     
    h = sign(sum(x * w,2));

    % replace zero (0) with one (1)
    h(h==0)=1;
            
    Ein = (sum(abs(y - h))/2) / N;
        
    sum_Ein = sum_Ein + Ein;
       
    % decrement runs counter
    r = r - 1;
    
end

avg_Ein = sum_Ein / num_Ein;

fprintf('Average Ein(g): '); 
fprintf('%f: \n', avg_Ein);









