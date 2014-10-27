n = 10000;
dcv = 50;
delta = 0.05;

a = homework_4_generalization_error_ex_2_vc(n, dcv, delta);
b = homework_4_generalization_error_ex_2_rademacher(n, dcv, delta);
c = homework_4_generalization_error_ex_2_parrondo(n, dcv, delta);
d = homework_4_generalization_error_ex_2_devroye(n, dcv, delta);

fprintf('a (N:%i): %f\n', n, a);
fprintf('b (N:%i): %f\n', n, b);
fprintf('c (N:%i): %f\n', n, c);
fprintf('d (N:%i): %f\n', n, d);

n = 5;

a = homework_4_generalization_error_ex_2_vc(n, dcv, delta);
b = homework_4_generalization_error_ex_2_rademacher(n, dcv, delta);
c = homework_4_generalization_error_ex_2_parrondo(n, dcv, delta);
d = homework_4_generalization_error_ex_2_devroye(n, dcv, delta);

fprintf('a (N:%i): %f\n', n, a);
fprintf('b (N:%i): %f\n', n, b);
fprintf('c (N:%i): %f\n', n, c);
fprintf('d (N:%i): %f\n', n, d);

%N = zeros(1,10000);
%A = zeros(1,10000);
%B = zeros(1,10000);
%C = zeros(1,10000);
%D = zeros(1,10000);

%for i = 1 : 10000
    
%    N(i) = i; 
%    A(i) = homework_4_generalization_error_ex_2_vc(i, dcv, delta);
%    B(i) = homework_4_generalization_error_ex_2_rademacher(i, dcv, delta);
%    C(i) = homework_4_generalization_error_ex_2_parrondo(i, dcv, delta);
%    D(i) = homework_4_generalization_error_ex_2_devroye(i, dcv, delta);
    
%end

%plot(N , A, 'color', 'g'); hold on;
%plot(N , B, 'color', 'r'); hold on;
%plot(N , C, 'color', 'b'); hold on;
%plot(N , D, 'color', 'k');