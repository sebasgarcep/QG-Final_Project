function Xa = EnKF(y, Xb, H, dev, model)
    [ny, ~] = size(y);
    [nx, N] = size(Xb);
    
    % Calulcate stuff
    R_inv = (dev ^ (- 2)) * speye(ny);
    Ys = y * ones(1, N) + dev * randn(ny, N);
    mXb = mean(Xb, 2);
    A = Xb - mXb * ones(1, N);
    Q = A * A' / (N - 1);
    
    % Build localization matrix
    Qloc = sparse(nx, nx);
    for i = 1:nx
        p = model.influence(i);
        Qloc(i, p) = Q(i, p);
    end
    
    % Analysis step
    K = (inv(Qloc) + H' * R_inv * H) \ H' * R_inv;
    Xa = Xb + K * (Ys - H * Xb);
end

