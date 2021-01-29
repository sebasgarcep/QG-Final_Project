function Xa = ModifiedCholesky(y, Xb, H, ts, dev, model)
    % Derived variables
    [ny, ~] = size(y);
    [nx, N] = size(Xb);
 
    X = Xb - mean(Xb, 2) * ones(1, N);
 
    T_hat = sparse(nx, nx);
    D_hat = sparse(nx, nx);
    for i = 1:nx
        ei = X(i, :)';
 
        if i > 1
            % calculate predecessors
            p = model.influence(i);
            p = p(p < i);
 
            % calculate beta
            Zi = X(p, :)';
 
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
            Bi = V(:,1:g) * (S(1:g,1:g) \ U(:,1:g)') * X(i, :)';
 
            % calculate the residuals on the regression
            ei = ei - X(p, :)' * Bi;
 
            T_hat(i, p) = - Bi;
        end
 
        D_hat(i, i) = cov(ei);
        T_hat(i, i) = 1;
    end
 
    B_hat_inv = T_hat' * (D_hat \ T_hat);
    R_inv = (dev .^ -2) * speye(ny);
    Ys = y * ones(1, N) + dev * randn(ny, N);
    K = (B_hat_inv + H' * R_inv * H) \ H' * R_inv;
    Xa = Xb + K * (Ys - H * Xb);
end