clc;

N = [25 35; 10 35]; % [Ntrain_1 N_1; Ntrain_2 N_2; ...]

K = 3:7;

data = importdata('in.dta');

Xin = data(:,1:2);
yin = data(:,3);

data = importdata('out.dta');

Xout = data(:,1:2);
yout = data(:,3);

for z = 1 : size(N,1)

    for a = 1 : size(K,2)

        % Execute linear regression algorithm and compute Ein

        X = Xin(1:N(z,1),:);
        y = yin(1:N(z,1),:);

        X = [   ones(size(X,1), 1) ...
                X(:,1) ...
                X(:,2) ...
                X(:,1).^2 ...
                X(:,2).^2 ...
                X(:,1).*X(:,2) ...
                abs(X(:,1)-X(:,2)) ...
                abs(X(:,1)+X(:,2))];

        k = K(a);

        X = X(:,1:k+1);

        w = pinv(X) * y;

        h = zeros(size(X,1),1);
        for b = 1 : size(X,1)  

            h_tmp = 0;

            for c = 1 : k+1

                h_tmp = h_tmp + w(c) * X(b,c);

            end

            h(b) = sign(h_tmp);

        end

        ein = (sum(abs(y - h))/2) / size(X,1);

        fprintf('Ein(g): %f, ', ein);

        % Compute Eval

        X = Xin(N(z,1)+1:N(z,2),:);
        y = yin(N(z,1)+1:N(z,2));

        X = [   ones(size(X,1), 1) ...
                X(:,1) ...
                X(:,2) ...
                X(:,1).^2 ...
                X(:,2).^2 ...
                X(:,1).*X(:,2) ...
                abs(X(:,1)-X(:,2)) ...
                abs(X(:,1)+X(:,2))];

        X = X(:,1:k+1);

        h = zeros(size(X,1),1);
        for b = 1 : size(X,1)  

            h_tmp = 0;

            for c = 1 : k+1

                h_tmp = h_tmp + w(c) * X(b,c);

            end

            h(b) = sign(h_tmp);

        end

        eval = (sum(abs(y - h))/2) / size(X,1);

        fprintf('Eval(g): %f, ', eval);

        % Compute Eout

        X = Xout;
        y = yout;

        X = [   ones(size(X,1), 1) ...
                X(:,1) ...
                X(:,2) ...
                X(:,1).^2 ...
                X(:,2).^2 ...
                X(:,1).*X(:,2) ...
                abs(X(:,1)-X(:,2)) ...
                abs(X(:,1)+X(:,2))];

        X = X(:,1:k+1);

        h = zeros(size(X,1),1);
        for b = 1 : size(X,1)  

            h_tmp = 0;

            for c = 1 : k+1

                h_tmp = h_tmp + w(c) * X(b,c);

            end

            h(b) = sign(h_tmp);

        end

        eout = (sum(abs(y - h))/2) / size(X,1);

        fprintf('Eout(g): %f, k: %i, Ntrain: %i, Nval: %i \n', eout, k, N(z,1), N(z,2)-N(z,1));

    end
    
end