r = 100000; % number of experiment runs
c = 1000; % number of coins
f = 10; % number of flips for each coin

sum_v1 = 0;
sum_vrand = 0;
sum_vmin = 0;

for i = 1 : r
    
    x = randi([0 1], c, f); % experiment (head: 1, tail: 0)

    c1 = x(1,:); % first coin flipped
    crand = x(randi(c),:); % coin choosen randomly
    [s,ix] = min(sum(x,2)); cmin = x(ix,:); % coin with minimum frequency of heads

    v1 = sum(c1)/10;
    vrand = sum(crand)/10;
    vmin = sum(cmin)/10;

    sum_v1 = sum_v1 + v1;
    sum_vrand = sum_vrand + vrand;
    sum_vmin = sum_vmin + vmin;
    
end
    
avg_v1 = sum_v1 / r;
avg_vrand = sum_vrand / r;
avg_vmin = sum_vmin / r;