clc;

% define number of runs
r = 1000;

% define number of points in data set
N = 100;

doplot = 0;

sumr = 0;
numr = r;

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
         
    i = 0;

    converged = 0;
    
    % start learning algorithm
    while converged == 0

        % init empty misclassified points vector
        mp = int16([]);

        % collect misclassified points
        for a = 1 : N        
            ha = sign(w(1) * 1 + w(2) * x(a,1) + w(3) * x(a,2));
            ha(ha==0)=1;
            if y(a) ~= ha
                mp = [mp ; a]; %#ok<AGROW>
            end 
        end
        
        if ~ isempty(mp)
        
            % randomly choose misclassified point
            m = mp(randi(length(mp)));

            % adjust weights
            w(1) = w(1) + y(m) * 1;
            w(2) = w(2) + y(m) * x(m,1);
            w(3) = w(3) + y(m) * x(m,2);
            
        end
        
        h = zeros(1,N)';

        for b = 1 : N        
            h(b) = sign(w(1) * 1 + w(2) * x(b,1) + w(3) * x(b,2));                
        end

        % replace zero (0) with one (1)
        h(h==0)=1;

        % check if algorithm converged
        if isequal(y,h)
            converged = 1;
        end

        % increment iteration counter
        i = i + 1;

    end    
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
    
    sumr = sumr + i;
        
    % decrement runs counter
    r = r - 1;
    
end

avgr = sumr / numr;

fprintf('Average number of iterations (%i runs): ', numr); 
fprintf('%f: \n', avgr);






