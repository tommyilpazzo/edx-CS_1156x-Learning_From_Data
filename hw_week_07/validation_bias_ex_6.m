clc;

N = 1000000;

E = unifrnd(0, 1, N, 2);

e1 = mean(E(:,1),1);
e2 = mean(E(:,2),1);

e = mean(min(E(:,1),E(:,2)),1);

fprintf('E[e1]: %f, E[e2]: %f, E[e]: %f\n', e1, e2, e);