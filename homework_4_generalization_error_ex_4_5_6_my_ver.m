clc;

r = 1000; %runs
e = 2; %examples

%f:[-1,1]->R
%f(x) = sin(pi*X)

X=linspace(-1,1,r);
Y=sin(pi*X);

i = r;

A = zeros(1,r);

while i > 0
    
    E = fix (unifrnd (1, r, e, 1)); 
    
    Xr = X(E);
    Yr = Y(E);
        
    a = Yr * pinv(Xr);
        
    A(i) = a;
    
    plot([-1;1],[a*-1;a*1],'color','y');
    hold on;
    
    i = i - 1;
    
end

plot(X,Y,'color','k'), axis([-1 1 -1 1]);
hold on;

aavg = (round(mean(A)*100))/100;

Yaavg = aavg * X;

bias = (round(((sum((Y - Yaavg).^2))/r)*100))/100;

V = zeros(1,r);

for c = 1 : r
   
    Ya = A(c) * X;
    V(c) = (round(((sum((Ya - Yaavg).^2))/r)*100))/100;
     
end

variance = mean(V);

plot([-1;1],[aavg*-1;aavg*1],'color','k');
hold off;

fprintf('Average a: %f\n', aavg);
fprintf('Bias: %f\n', bias);
fprintf('Variance: %f\n', variance);
