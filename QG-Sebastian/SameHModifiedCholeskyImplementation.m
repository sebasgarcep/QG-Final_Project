clc;
clear all;
close all;
warning('off', 'all');

manager = QGManager();

% Initialize variables
N = 40;
t = 12;
n = 127;
m = 127;
l = 1;
r = 1;
s = 1;
ts = 0.1;

% Derived variables
nv = n * m * l;

% load ensembles
ens = zeros(t * N, nv);
for h = 1:t
    for k = 1:N
        mat = manager.read(['QGe_t', num2str(h), '_n', num2str(k), '.nc']);
        mat = mat(2:(n + 1), 2:(n + 1));
        vec = mat(:);
        ens(h * k, :) = vec;
    end
end

y = zeros(t, nv);
for h = 1:t
    mat = manager.read(['QGy_t', num2str(h), '.nc']);
    mat = mat(2:(n + 1), 2:(n + 1));
    vec = mat(:);
    y(h, :) = vec;
end

for p = 0.2:0.2:1
    H = zeros(nv, 1);
    H(randperm(nv, round(p * nv))) = 1;
    
    Xb = ens(1:N, :)';
    Ub = Xb - mean(Xb, 2) * ones(1, N);
    X = Ub';

    T_hat = sparse(nv, nv);
    D_hat = sparse(nv, nv);
    beta = sparse(nv, nv);
    e = zeros(N, nv);

    for i = 1:nv
        e(:, i) = X(:, i);

        if i > 1
            % calculate predecessors
            p = predecessors(n, m, l, r, s, i);

            % calculate beta
            Zi = X(:, p);

            % regularization
            [U, S, V] = svd(Zi, 'econ');
            dS = diag(S);
            mS = length(S);
            maxS = max(dS);
            g = 0;
            while g < mS
                if dS(g + 1) / maxS < ts
                   break;
                end
                g = g + 1;
            end
            Bi = V(:,1:g) * (S(1:g,1:g) \ U(:,1:g)') * X(:, i);
            beta(i, p) = Bi;

            % calculate the residuals on the regression
            sum = X(:, p) * beta(i, p)';
            e(:, i) = e(:, i) - sum;
        end

        D_hat(i, i) = cov(e(:, i));
        T_hat(i, i) = 1;
    end

    T_hat = T_hat - beta;

    B_hat_inv = T_hat' * (D_hat \ T_hat);
end