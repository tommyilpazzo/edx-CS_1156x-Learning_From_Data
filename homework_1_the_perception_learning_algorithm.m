clc;

% define number of runs
r = 1000;

% define number of points in data set
N = 100;

% define point set size per run in order to identify the disagreement
% probability
NP = 1000;

doplot = 0;

sumr = 0;
numr = r;

sumdisp = 0;
numdisp = r;

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
    
    % define starting weights
    %w = zeros(1,3);
    w0 = 0;
    w1 = 0;
    w2 = 0;

    i = 0;

    converged = 0;

    % start learning algorithm
    while converged == 0

        % init empty misclassified points vector
        mp = int16([]);

        % collect misclassified points
        for a = 1 : N        
            ha = sign(w0 * 1 + w1 * x(a,1) + w2 * x(a,2));
            ha(ha==0)=1;
            if y(a) ~= ha
                mp = [mp ; a]; %#ok<AGROW>
            end 
        end
        
        if ~ isempty(mp)
        
            % randomly choose misclassified point
            m = mp(randi(length(mp)));

            % adjust weights
            w0 = w0 + y(m) * 1;
            w1 = w1 + y(m) * x(m,1);
            w2 = w2 + y(m) * x(m,2);
            
        end

        h = zeros(1,N);
        h = h';

        for b = 1 : N        
            h(b) = sign(w0 * 1 + w1 * x(b,1) + w2 * x(b,2));                
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
        p_y = (-w1/w2) * p_x +  (-w0/w2);
        plot(p_x ,p_y,'color','r'), legend('target function','converged hypothesys')
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
    
    % calculate disagreement probability
    disx = (rand(NP,2)*2)-1;
    disy = sign(-f_delta_x*disx(:,2) + f_delta_y*disx(:,1) + f_delta_x*f_q);
    disg = sign(w0 * 1 + w1 * disx(:,1) + w2 * disx(:,2));h(h==0)=1;
    disy(disy==0)=1;
    disg(disg==0)=1;
    diserr = 0;
    for j = 1 : NP
        if disy(j) ~= disg(j)
           diserr = diserr + 1; 
        end
    end
    disp = diserr / NP;
    
    sumdisp = sumdisp + disp;
    
    % decrement runs counter
    r = r - 1;
    
end

avgr = sumr / numr;
avgdisp = sumdisp / numdisp;

fprintf('Average number of iterations (%i runs): ', numr); 
fprintf('%f: \n', avgr); 

fprintf('Average P[f(x)~=g(x)]: '); 
fprintf('%f: \n', avgdisp); 








