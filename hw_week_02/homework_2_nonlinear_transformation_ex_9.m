clc;

% define number of runs
r = 1000;

% define number of points in data set
N = 1000;

% define number of out of sample points
Nout = 1000;

% define data set
X = (rand(N,2)*2)-1;

% define data set
Xout = (rand(Nout,2)*2)-1;

% evaluate target function on each x_n
Y = sign(X(:,1).^2 + X(:,2).^2 - 0.6);
% replace zero (0) with one (1)
Y(Y==0)=1;

X = [ones(N,1) X(:,1) X(:,2) (X(:,1).*X(:,2)) (X(:,1).^2) (X(:,2).^2)]; 

Xout = [ones(N,1) Xout(:,1) Xout(:,2) (Xout(:,1).*Xout(:,2)) (Xout(:,1).^2) (Xout(:,2).^2)]; 

%flip the sign of the ourput in a random 10% subset
noisy_indices = randperm(N, round(N/10));
Y(noisy_indices) = -Y(noisy_indices);

% calculate weights using linear regression algorithm
w = pinv(X) * Y;

wa = [-1; -0.05; 0.08; 0.13; 1.5; 1.5];
wb = [-1; -0.05; 0.08; 0.13; 1.5; 15]; 
wc = [-1; -0.05; 0.08; 0.13; 15; 1.5]; 
wd = [-1; -1.5; 0.08; 0.13; 0.05; 0.05];
we = [-1; -0.05; 0.08; 1.5; 0.15; 0.15];

h = sign(sum(Xout * w, 2));
ha = sign(sum(Xout * wa, 2));
hb = sign(sum(Xout * wb, 2));
hc = sign(sum(Xout * wc, 2));
hd =  sign(sum(Xout * wd, 2));
he =  sign(sum(Xout * we, 2));

da = sum(abs(h-ha))/2 ;
db = sum(abs(h-hb))/2 ;
dc = sum(abs(h-hc))/2 ;
dd = sum(abs(h-hd))/2 ;
de = sum(abs(h-he))/2 ;

d = [da db dc dd de];

[c, idx] = min(d);

% decrement runs counter
r = r - 1;

% replace zero (0) with one (1)
h(h==0)=1;

q = ['a' 'b' 'c' 'd' 'e'];

fprintf('%c \n', q(idx));










