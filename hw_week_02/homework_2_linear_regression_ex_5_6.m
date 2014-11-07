clc;

% define number of runs
r = 1000;

% define number of points in data set
N = 100;
Nout = 1000;

% define point set size per run in order to identify the disagreement
% probability
NP = 1000;

doplot = 0;

sum_Ein = 0;
num_Ein = r;

sum_Eout = 0;
num_Eout = r;
while r > 0

    % define target function 
    f_xy = (rand(2)*2)-1; %[[x1,y1],[x2,y2]]
    f_delta_x = f_xy(2,1)-f_xy(1,1);
    f_delta_y = f_xy(2,2)-f_xy(1,2);
    f_m = f_delta_y / f_delta_x; 
    f_q = -f_m*f_xy(1,1) + f_xy(1,2);
    
    % define data set
    x = (rand(N,2)*2)-1;
        
    % evaluate target function on each x_n
    % y = sign(-f_delta_x*y + f_delta_y*x + f_delta_x*f_q)
    y = sign(-f_delta_x*x(:,2) + f_delta_y*x(:,1) + f_delta_x*f_q);
    % replace zero (0) with one (1)
    y(y==0)=1;
    
    % calculate weights using linear regression algorithm
    w = pinv([ones(N,1) x]) * y;
     
    h = zeros(N,1);

    for b = 1 : N        
        h(b) = sign(w(1) * 1 + w(2) * x(b,1) + w(3) * x(b,2));                
    end

    % replace zero (0) with one (1)
    h(h==0)=1;
    
    Ein = (sum(abs(y - h))/2) / N;
    
    sum_Ein = sum_Ein + Ein;
    
    % define Nout out of sample points
    xout = (rand(Nout,2)*2)-1;
        
    % evaluate target function on each xout_n
    % y = sign(-f_delta_x*y + f_delta_y*x + f_delta_x*f_q)
    yout = sign(-f_delta_x*xout(:,2) + f_delta_y*xout(:,1) + f_delta_x*f_q);
    % replace zero (0) with one (1)
    yout(yout==0)=1;
    
    hout = zeros(Nout,1);

    for b = 1 : Nout        
        hout(b) = sign(w(1) * 1 + w(2) * xout(b,1) + w(3) * xout(b,2));                
    end

    % replace zero (0) with one (1)
    hout(hout==0)=1;
    
    Eout = (sum(abs(yout - hout))/2) / Nout;
    
    sum_Eout = sum_Eout + Eout;
    
    if doplot == 1
        % plot target function
        p_x = [-1,1];
        p_y = f_m * (p_x - f_xy(1,1)) + f_xy(1,2);
        plot(p_x ,p_y,'color','g'), xlabel('x'), ylabel('y'), title('Perceptron Learning Algorithm'), axis([-1 1 -1 1])
        hold on
        % plot converged hypothesys
        p_x = [-1,1];
        p_y = (-w(2)/w(3)) * p_x +  (-w(1)/w(3));
        plot(p_x ,p_y,'color','r'), legend('target function','hypothesys')
        hold on
        % plot data set input
        for k = 1 : N
            if(y(k) == 1)
                plot(x(k,1),x(k,2),'+','color',[0 0 1]);
            else
                plot(x(k,1),x(k,2),'o','color',[0 0 0]);
            end
        end
        hold off % reset hold state
    end
        
    % decrement runs counter
    r = r - 1;
    
end

avg_Ein = sum_Ein / num_Ein;

fprintf('Average Ein(g): '); 
fprintf('%f: \n', avg_Ein);

avg_Eout = sum_Eout / num_Eout;

fprintf('Average Eout(g): '); 
fprintf('%f: \n', avg_Eout);









